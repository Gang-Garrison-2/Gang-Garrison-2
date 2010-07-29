{
    var xmid, ymid, dist;
    xmid = view_xview[0] + view_wview[0]/2;
    ymid = view_yview[0] + view_hview[0]/2;
    
    dist = sqrt((xmid-argument0)*(xmid-argument0) + (ymid-argument1)*(ymid-argument1));
    
    if(dist<300) {
        return 1;
    } else if(dist>1500) {
        return 0;
    } else {
        return ((1500-dist)/1200);
    }
}