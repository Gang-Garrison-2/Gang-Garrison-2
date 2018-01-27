var hs, cp;
hs = hspeed * image_xscale;
cp = (0.866*hs + 0.5*vspeed) * (3+(3+sin(current_time/203))/3*sin(current_time/75 + sin(current_time/250)*0.7))/3;

if(cp<=0.5) {
    return 0;
} else if(cp < 2.5) {
    return 1;
} else if(cp < 4.5) {
    return 2;
} else if(cp < 7) {
    return 3;
} else {
    return 4;
}
