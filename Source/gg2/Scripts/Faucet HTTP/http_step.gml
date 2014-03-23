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

// Steps the HTTP client. This is what makes everything actually happen.
// Call it each step. Returns whether or not the request has finished.
// real http_step(real client)

// client - HttpClient object

// Return value is either:
// 0 - In progress
// 1 - Done or Errored

// Example usage:
// req = http_new_get("http://example.com/x.txt");
// while (http_step(req)) {}
// if (http_status_code(req) != 200) {
//     // Errored!
// } else {
//     // Hasn't errored, do stuff here.
// }

var client;
client = argument0;

__http_client_step(client);

if (client.errored || client.state == 2)
    return 1;
else
    return 0;
