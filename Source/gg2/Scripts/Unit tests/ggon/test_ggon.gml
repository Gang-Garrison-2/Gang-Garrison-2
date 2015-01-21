// void test_ggon()
// GGON unit test

test_unit_begin();

// completely valid bareword string
test_assert_equals(
    ggon_decode('_.+-2717281982abcdfoobar'),
    '_.+-2717281982abcdfoobar');

test_assert_equals(
    ggon_decode("'foobar\n\r\t\0blah'"),
    "foobar" + chr(10) + chr(13) + chr(9) + chr(0) + "blah"
);

var map;

map = ggon_decode("{}");
test_assert_equals(0, ds_map_size(map));
ggon_destroy_map(map);

map = ggon_decode("{foo:bar, 
'baz': 'qux' }");
test_assert_equals(2, ds_map_size(map));
test_assert_map_key_value(map, "foo", "bar");
test_assert_map_key_value(map, "baz", "qux");
ggon_destroy_map(map);

map = ggon_decode("[]");
test_assert_equals(1, ds_map_size(map));
test_assert_map_key_value(map, "length", "0");
ggon_destroy_map(map);

map = ggon_decode("[a,b]");
test_assert_equals(3, ds_map_size(map));
test_assert_map_key_value(map, "length", "2");
test_assert_map_key_value(map, "0", "a");
test_assert_map_key_value(map, "1", "b");
ggon_destroy_map(map);

// contrived, but probably semi-representative sample
map = ggon_decode("{
    items: [
        {
            type: foo,
            x: 12.0,
            y: 13.5
        },
        {
            type: bar,
            x: 12.0,
            y: 13.5,
            'sub items': []
        }
    ]
}");
test_assert_equals(1, ds_map_size(map));
var items;
items = ds_map_find_value(map, 'items');
test_assert_equals(3, ds_map_size(items));
test_assert_map_key_value(items, 'length', '2');
var item;
item = ds_map_find_value(items, '0');
test_assert_equals(3, ds_map_size(item));
test_assert_map_key_value(item, 'type', 'foo');
test_assert_map_key_value(item, 'x', '12.0');
test_assert_map_key_value(item, 'y', '13.5');
item = ds_map_find_value(items, '1');
test_assert_equals(4, ds_map_size(item));
test_assert_map_key_value(item, 'type', 'bar');
test_assert_map_key_value(item, 'x', '12.0');
test_assert_map_key_value(item, 'y', '13.5');
var sub_items;
sub_items = ds_map_find_value(item, 'sub items');
test_assert_equals(1, ds_map_size(sub_items));
test_assert_map_key_value(sub_items, 'length', '0');

var out;
out = ggon_encode(map);
test_assert_equals(out, "{items:[{type:foo,x:12.0,y:13.5},{'sub items':[],type:bar,x:12.0,y:13.5}]}");

ggon_destroy_map(map);

// valid empty GGON list
map = ds_map_create();
ds_map_add(map, "length", "0");
out = ggon_encode(map);
test_assert_equals("[]", out);
ggon_destroy_map(map);

// valid GGON list
map = ds_map_create();
ds_map_add(map, "length", "2");
ds_map_add(map, "0", "a");
ds_map_add(map, "1", "b");
out = ggon_encode(map);
test_assert_equals("[a,b]", out);
ggon_destroy_map(map);

// length is invalid, not valid GGON list
map = ds_map_create();
ds_map_add(map, "length", "a");
ds_map_add(map, "0", "a");
ds_map_add(map, "1", "b");
out = ggon_encode(map);
test_assert_equals('{', string_char_at(out, 1));
ggon_destroy_map(map);

// length is wrong, also not valid GGON list
map = ds_map_create();
ds_map_add(map, "length", "3");
ds_map_add(map, "0", "a");
ds_map_add(map, "1", "b");
out = ggon_encode(map);
test_assert_equals('{', string_char_at(out, 1));
ggon_destroy_map(map);

// sparse, not a valid GGON list
map = ds_map_create();
ds_map_add(map, "length", "3");
ds_map_add(map, "0", "a");
ds_map_add(map, "2", "c");
out = ggon_encode(map);
test_assert_equals('{', string_char_at(out, 1));
ggon_destroy_map(map);

test_unit_end();
