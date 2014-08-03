/**
 * argument0: The player whose rewards were updated
 * argument1: The new rewards value
 */

var player, rewardString;
player = argument0;
rewardString = argument1;

parseRewards(rewardString, player.rewards);
parseBadges(player.rewards, player.badges);
