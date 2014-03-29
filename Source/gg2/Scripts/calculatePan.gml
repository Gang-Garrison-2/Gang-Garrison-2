{
    var xmid;
    xmid = view_xview[0] + view_wview[0]/2;
    
    if((argument0-xmid)<-400) {
        return -1;
    } else if((argument0-xmid)>400) {
        return 1;
    } else {
        return ((argument0-xmid)/400);
    }
}