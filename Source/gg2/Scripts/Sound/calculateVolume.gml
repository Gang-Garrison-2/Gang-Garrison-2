{
    var xmid, ymid, dist, amp;
    xmid = view_xview[0] + view_wview[0]/2;
    ymid = view_yview[0] + view_hview[0]/2;
    
    dist = sqrt(sqr(xmid-argument0) + sqr(ymid-argument1));
    
    if(dist<300) {
        return 1;
    } else if(dist>800) {
        return 0;
    } else {
        amp = sqr((800-dist)/500);
        return (amp);
    }
}
