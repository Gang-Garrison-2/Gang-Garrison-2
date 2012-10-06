/*
**  Usage:
**      md5(str)
**
**  Arguments:
**      str     string from which to compute an MD5 hash (RFC 1321)
**
**  Returns:
**      an MD5 hash (RFC 1321) computed from the given string
**
**  Notes:
**      This will only work with strings shorter than 512 megabytes.
**      Precision problems make this unusable in Game Maker 6.
**      For speed this function precomputes four tables in the form
**      of global arrays called MD5k[], MD5g[], MD5r[], and MD5s[].
**
**  GMLscripts.com
*/
{
    var str,uint,grp,rol,i,j,h,len,pos,w,a,b,c,d,e,f,temp,digest;
    str = argument0;
    if (!variable_global_exists("MD5k")) {
        globalvar MD5k,MD5g,MD5r,MD5s;
        grp  = "00010203040506070809101112131415";
        grp += "01061100051015040914030813020712";
        grp += "05081114010407101300030609121502";
        grp += "00071405120310010815061304110209";
        rol  = "07121722071217220712172207121722";
        rol += "05091420050914200509142005091420";
        rol += "04111623041116230411162304111623";
        rol += "06101521061015210610152106101521";
        for(i=0; i<64; i+=1) {
            MD5k[i] = floor(abs(sin(i+1))*(1 << 32));
            MD5g[i] = real(string_copy(grp,i*2+1,2));
            MD5r[i] = real(string_copy(rol,i*2+1,2));
            MD5s[i] = 32 - MD5r[i];
        }
    }
    uint = $FFFFFFFF;
    h[0] = $67452301;
    h[1] = $EFCDAB89;
    h[2] = $98BADCFE;
    h[3] = $10325476;
    len = 8 * string_length(str);
    str += chr(128);
    while ((string_length(str) mod 64) != 56) str += chr(0);
    for (i=0; i<64; i+=8) str += chr(len >> i);
    pos = 0;
    for (j=0; j<string_length(str); j+=64) {
        for (i=0; i<16; i+=1) {
            w[i] = ord(string_char_at(str,pos+4));
            w[i] = ord(string_char_at(str,pos+3)) | (w[i] << 8);
            w[i] = ord(string_char_at(str,pos+2)) | (w[i] << 8);
            w[i] = ord(string_char_at(str,pos+1)) | (w[i] << 8);
            pos += 4;
        }
        a = h[0];
        b = h[1];
        c = h[2];
        d = h[3];
        for (i=0; i<64; i+=1) {
            if      (i < 16) f = (d ^ (b & (c ^ d)));
            else if (i < 32) f = (c ^ (d & (b ^ c)));
            else if (i < 48) f = (b ^ c ^ d);
            else             f = (c ^ (b | (~d)));
            temp = d;
            d = c;
            c = b;
            e = uint & (a + f + MD5k[i] + w[MD5g[i]]);
            b = uint & ((uint & (e << MD5r[i]) | (e >> MD5s[i])) + b);
            a = temp;
        }
        h[0] = uint & (h[0] + a);
        h[1] = uint & (h[1] + b);
        h[2] = uint & (h[2] + c);
        h[3] = uint & (h[3] + d);
    }
    digest = "";
    for (j=0; j<4; j+=1) {
        for (i=0; i<32; i+=8) {
            digest += string_char_at("0123456789abcdef",1+($F & h[j] >> i+4));
            digest += string_char_at("0123456789abcdef",1+($F & h[j] >> i));
        }
    }
    return digest;
}
