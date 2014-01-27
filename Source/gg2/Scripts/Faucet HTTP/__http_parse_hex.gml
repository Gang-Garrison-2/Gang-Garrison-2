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

// Takes a lowercase hexadecimal string and returns its integer value
// real __http_parse_hex(string hexString)

// Return value is the whole number value (or -1 if invalid)
// Only works for whole numbers (non-fractional numbers >= 0) and lowercase hex

var hexString;
hexString = argument0;

var result, hexValues;
result = 0;
hexValues = "0123456789abcdef";

var i;
for (i = 1; i <= string_length(hexString); i += 1) {
    result *= 16;
    var digit;
    digit = string_pos(string_char_at(hexString, i), hexValues) - 1;
    if (digit == -1)
        return -1;
    result += digit;
}

return result;
