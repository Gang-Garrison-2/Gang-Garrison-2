GGON - Gang Garrison Object Notation
====================================

Notation
--------

GGON has three primitives:

* Strings - These convert to and from GML strings. There are two styles:
    * Unquoted:
    
            foo
    
      Strings don't need quotes if they fit the format `[a-zA-Z0-9\.\-\+]+`
    
      This means all of the following are valid unquoted strings:
    
      * 12.5
      * true
      * under_scores
      * camelCase
      * things-with-dashes
      * -12.2e75
      * -
      * +
      * .2
      * object.style
      * domain.com
    * Quoted:
    
            'foo bar'
    
      These allow arbitrary characters and support six escape codes:
    
      * `\\` - Backslash
      * `\'` - Single quote
      * `\n` - Newline
      * `\r` - Carriage Return
      * `\t` - Tab
      * `\0` - Null byte
    
      Only single quotes are allowed because double quotes are dumb.
    
* Maps. These look much like JSON Objects and convert to and from GML ds_maps. They map string keys to string or map values:
  
        {
            someKey: someValue,
            'some key': someValue,
            nestedMap: {}
        }

* Lists. These look much like JSON Arrays. Unfortunately, for reasons described further down, these *also* convert to and from GML ds\_maps, **not ds\_lists**. They are essentially syntactic sugar for a map with a `length` key and a set of contiguous, consecutive, zero-indexed integer keys. An example of a list:

        [
            foo,
            bar,
            baz,
            {
                nested: maps
            }
        ]

    This is exactly equivalent to the following map:

        {
            length: 4,
            0: foo,
            1: bar,
            2: baz,
            3: {
                nested: maps
            }
        }

    Indeed, they will decode to exactly the same thing.

GGON ignores whitespace, so you can format things how you like.

If you're wondering what encoding scheme GGON uses, its core syntax is ASCII. You can put whatever you want in your strings. UTF-8 would obviously be compatible, but Gang Garrison 2 doesn't really understand that.

Usage
-----

From GML, it is easy to work with. To make a map, just make a ds\_map then use `ggon_encode`:

    var map, ggon;
    
    map = ds_map_create();
    ds_map_add(map, 'someKey', 'someValue');
    ds_map_add(map, 'some key', 'someValue');
    
    ggon = ggon_encode(map);
    ds_map_destroy(map);

`ggon_encode` will assume reals are handles to a ds_map for creating a nested map. This means if you want to store a real, you need to convert it to a string. For example:

    var map, nestedMap, ggon;
    
    nestedMap = ds_map_create();
    ds_map_add(map, 'foo', 'bar');
    ds_map_add(map, 'foobar', 'qux');
    
    map = ds_map_create();
    ds_map_add(map, 'nest', nestedMap);
    ds_map_add(map, 'x', string(x));
    ds_map_add(map, 'y', string(y));
    
    ggon = ggon_encode(map);
    ds_map_destroy(map);
    ds_map_destroy(nestedMap);

Decoding works similarly - use `ggon_decode`:

    var ggon, map, foo, nestedMap, foobar;
    
    ggon = '{foo:bar,qux:{foobar:boo}}';
    map = ggon_decode(ggon);
    
    foo = ds_map_find_value(map, 'foo');
    nestedMap = ds_map_find_value(map, 'qux');
    foobar = ds_map_find_value(nestedMap, 'foobar');

Because ds\_maps produced by `ggon_decode` contain only string keys, they can be easily looped over:

    var key;
    for (key = ds_map_find_first(map); is_string(key); key = ds_map_find_next(map, key))
    {
        show_message(key + ': ' + ds_map_find_value(map, key));
    }

Sadly, because GML only has two types and hence you cannot distinguish between a ds\_map and ds\_list handle, GGON cannot use ds\_list for lists, and instead represents them using a ds\_map. Since this is rather awkward to work with directly, utility functions are provided to convert lists to maps and vice-versa. Convering a list to a map uses `ggon_list_to_map`:

    var list, map, ggon;
    list = ds_list_create();
    ds_list_add(list, "example");
    ds_list_add(list, ggon_decode('{some:map}'));
    
    map = ggon_list_to_map(list);
    ggon = ggon_encode(map);
    show_message(ggon); // output: [example,{some:map}]
    
    ds_map_destroy(map);
    ds_map_destroy(ds_list_find_value(list, 1));
    ds_list_destroy(list);

Converting back to a map uses `ggon_map_to_list`:

    var ggon, map, list;
    ggon = '[example,{some:map}]';
    map = ggon_decode(ggon);
    
    list = ggon_map_to_list(map);
    ds_map_destroy(map);
    show_message(ds_list_find_value(list, 0)); // output: example
    
    ds_map_destroy(ds_list_find_value(list, 1));
    ds_list_destroy(list);

Because destroying maps with nested maps can be a hastle, the convenience function `ggon_destroy_map` is provided:

    var map;
    map = ggon_decode('{this:{map:{has:{a:{lot:{of:{nesting:wow}}}}}}}');
    
    // Do stuff with map here
    
    ggon_destroy_map(map); // This destroys the map and every nested map to an infinite depth
