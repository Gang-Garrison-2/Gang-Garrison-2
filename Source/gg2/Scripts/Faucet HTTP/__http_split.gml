// ***
// This function forms part of Faucet HTTP v1.0
// https://github.com/TazeTSchnitzel/Faucet-HTTP-Extension
// 
// Copyright (c) 2013-2014, Andrea Faulds <ajf@ajf.me>
// 
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// ***

// real __http_split(string text, delimeter delimeter, real limit)
// Splits string into items

// text - string comma-separated values
// delimeter - delimeter to split by
// limit  if non-zero, maximum times to split text
// When limited, the remaining text will be left as the last item.
// E.g. splitting "1,2,3,4,5" with delimeter "," and limit 2 yields this list:
// "1", "2", "3,4,5"

// return value - ds_list containing strings of values

var text, delimeter, limit;
text = argument0;
delimeter = argument1;
limit = argument2;

var list, count;
list = ds_list_create();
count = 0;

while (string_pos(delimeter, text) != 0)
{
    ds_list_add(list, string_copy(text, 1, string_pos(delimeter,text) - 1));
    text = string_copy(text, string_pos(delimeter, text) + string_length(delimeter), string_length(text) - string_pos(delimeter, text));

    count += 1;
    if (limit and count == limit)
        break;
}
ds_list_add(list, text);

return list;
