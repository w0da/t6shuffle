/*
	Author: woda
	Date: 11/09/2023
*/

#include maps\mp\gametypes\_globallogic_utils;
#include maps\mp\_utility;
#include common_scripts\utility;






main() {
}

init()
{
// Create an array to store maps
    mapNames = [];
	
    // List of map names
    mapNames[0] = "mp_la";
    mapNames[1] = "mp_dockside";
    mapNames[2] = "mp_carrier";
    mapNames[3] = "mp_drone";
    mapNames[4] = "mp_express";
    mapNames[5] = "mp_hijacked";
    mapNames[6] = "mp_meltdown";
    mapNames[7] = "mp_overflow";
    mapNames[8] = "mp_nightclub";
    mapNames[9] = "mp_raid";
    mapNames[10] = "mp_slums";
    mapNames[11] = "mp_village";
    mapNames[12] = "mp_turbine";
    mapNames[13] = "mp_socotra";
    mapNames[14] = "mp_nuketown_2020";
    mapNames[15] = "mp_downhill";
    mapNames[16] = "mp_mirage";
    mapNames[17] = "mp_hydro";
    mapNames[18] = "mp_skate";
    mapNames[19] = "mp_concert";
    mapNames[20] = "mp_magma";
    mapNames[21] = "mp_vertigo";
    mapNames[22] = "mp_studio";
    mapNames[23] = "mp_uplink";
    mapNames[24] = "mp_bridge";
    mapNames[25] = "mp_castaway";
    mapNames[26] = "mp_paintball";
    mapNames[27] = "mp_dig";
    mapNames[28] = "mp_frostbite";
    mapNames[29] = "mp_pod";
    mapNames[30] = "mp_takeoff";

// Create an array to store gametypes
  gameTypes = [];
   
// Add game types -> change to suit your gamesettings.
// addGameType(fileName, weighting, minBots, maxBots, botSkill)
	
	
    gameTypes[gameTypes.size] = addGameType("dm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("tdm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("dom.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("dem.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("conf.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hq.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("ctf.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("koth.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("gun.cfg", 3, 2, 6, 2);
    gameTypes[gameTypes.size] = addGameType("oneflag.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("oic.cfg", 3, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("shrp.cfg", 3, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("sas.cfg", 3, 0, 6, 2);
	
	 
// Select a random map and game type based on their weightings
randomMapIndex = randomInt(mapNames.size);
selectedMap = mapNames[randomMapIndex];


// Extract attributes for the selected game type
	
selectedGameTypeData = selectRandomGametype(gameTypes);
   
    selectedGametype = selectedGameTypeData.fileName;
    minBots = selectedGameTypeData.minBots;
    maxBots = selectedGameTypeData.maxBots;
    botSkill = selectedGameTypeData.botSkill;


botAmount = randomBotsAmount(minBots, maxBots);
	
println("Selected bot amount:" + botAmount);
println("Selected Map : " + selectedMap);
println("Selected GameType : " + selectedGametype);

// Construct the sv_maprotation string
    sv_maprotationString = "exec " + selectedGametype + " map " + selectedMap;

// Spawn bots
    setDvar("bots_skill", botSkill);
    setDvar("bots_main_kickBotsAtEnd", true);
    setDvar("bots_manage_add",botAmount );
	
// Set additional dvars
    setDvar("bots_main_waitForHostTime", 15);    
	
// Set the sv_maprotation dvar
    setDvar("sv_maprotation", sv_maprotationString);

}

//Function returning gametype object
addGameType(fileName, weighting, minBots, maxBots, botSkill)
{ 

    // Initialize a new game type
    newGameType = spawnStruct();
    newGameType.fileName = fileName;
    newGameType.weighting = weighting;
    newGameType.minBots = minBots;
    newGameType.maxBots = maxBots;
    newGameType.botSkill = botSkill;
   
    return newGameType;
	
}

//Function returning random gametype based on weighting
selectRandomGametype(gameTypes)
{
    // Calculate the total weighting of all game types
    totalWeight = 0;
    foreach (type in gameTypes)
    {
        totalWeight += type.weighting;
    }

	
    // Generate a random number between 1 and the total weighting
    rand = randomInt(totalWeight) + 1;

    // Select a game type based on its weighting
    cumulativeWeight = 0;
    foreach (type in gameTypes)
    {
        cumulativeWeight += type.weighting;
        if (rand <= cumulativeWeight)
        {
            return type;
        }
    }
}

//Function returning random bot amount between min and max , always even.
randomBotsAmount(min, max)
{
    rand = randomInt(20); // Generate a random number between 0 and 19
    
    if (min == max) // If min equals max, return either min or max
    {
        return min;
    }

    if (min % 2 != 0) // Ensure min is an even number
    {
        min++; // Increment min if it's odd
    }

    if (max % 2 != 0) // Ensure max is an even number
    {
        max--; // Decrement max if it's odd
    }

    if (rand < 2 && (max >= 2))
    {
        return 0; // 0 bots
    }
    else if (rand < 8 && (max >= 2))
    {
        return 2; // 2 bots
    }
    else if (rand < 14 && (max >= 4))
    {
        return 4; // 4 bots
    }
    else if (rand < 18 && (max >= 6))
    {
        return 6; // 6 bots
    }
    else
    {
        return max; // max bots
    }
}
