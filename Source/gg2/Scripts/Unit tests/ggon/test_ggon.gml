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
test_assert_equals(true, ds_map_exists(map, "foo"));
test_assert_equals("bar", ds_map_find_value(map, "foo"));
test_assert_equals(true, ds_map_exists(map, "baz"));
test_assert_equals("qux", ds_map_find_value(map, "baz"));
ggon_destroy_map(map);

test_unit_end();
