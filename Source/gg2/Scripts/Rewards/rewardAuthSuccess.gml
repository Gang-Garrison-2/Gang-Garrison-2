var player, rewardString, rewardArray, i, rewardValue;
player = argument0;
rewardString = argument1;

// Golden weapons for all the classes
rewardArray[0] = "GWSc";
rewardArray[1] = "GWSo";
rewardArray[2] = "GWSn";
rewardArray[3] = "GWDe";
rewardArray[4] = "GWMe";
rewardArray[5] = "GWEn";
rewardArray[6] = "GWHe";
rewardArray[7] = "GWSp";
rewardArray[8] = "GWPy";
rewardArray[9] = "RESERVED";

// Golden statue
rewardArray[10] = "GS";

rewardValue = 0;
for(i=0; i<11; i+=1)
    if(string_pos(":"+rewardArray+":", rewardString))
        rewardValue |= (1<<i);
        
sendEventUpdateRewards(player, rewardValue);
doEventUpdateRewards(player, rewardValue);
