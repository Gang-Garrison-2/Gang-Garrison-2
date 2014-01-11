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

// Gets the reason phrase
// string http_reason_phrase(real client)

// client - HttpClient object
// Return value is either:
// * "", if the request has not yet finished
// * an internal Faucet HTTP error message, if there was one
// * the reason phrase of the HTTP request

// "The Status-Code element is a 3-digit integer result code of the
// attempt to understand and satisfy the request. These codes are fully
// defined in section 10. The Reason-Phrase is intended to give a short
// textual description of the Status-Code. The Status-Code is intended
// for use by automata and the Reason-Phrase is intended for the human
// user. The client is not required to examine or display the Reason-
// Phrase."

// See also: http_status_code, gets the Status-Code

var client;
client = argument0;

if (client.errored)
    return client.error;
else if (client.state == 2)
    return client.reasonPhrase;
else
    return "";
