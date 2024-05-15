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
    mapNames = [];

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

    gameTypes = [];

    gameTypes[gameTypes.size] = addGameType("hc_dm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_tdm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_dom.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_dem.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_conf.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_hq.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_ctf.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_koth.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_gun.cfg", 3, 2, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_oneflag.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("oic.cfg", 3, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("shrp.cfg", 3, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("sas.cfg", 3, 0, 6, 2);
	
	    
    gameTypes[gameTypes.size] = addGameType("rs_tdm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_dom.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_dem.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_conf.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_hq.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_ctf.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_koth.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_gun.cfg", 3, 2, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_oneflag.cfg", 2, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("rs_dm.cfg", 8, 0, 6, 2);

    randomMapIndex = randomInt(mapNames.size);
    selectedMap = mapNames[randomMapIndex];

    selectedGameTypeData = selectRandomGametype(gameTypes);

    selectedGametype = selectedGameTypeData.fileName;
    minBots = selectedGameTypeData.minBots;
    maxBots = selectedGameTypeData.maxBots;
    botSkill = selectedGameTypeData.botSkill;

    botAmount = randomBotsAmount(minBots, maxBots);

    println("Selected bot amount:" + botAmount);
    println("Selected Map : " + selectedMap);
    println("Selected GameType : " + selectedGametype);

    sv_maprotationString = "exec " + selectedGametype + " map " + selectedMap;

    setDvar("bots_skill", botSkill);
	setdvar( "bots_main_firstIsHost", true );
    setDvar("bots_main_kickBotsAtEnd", true);
    setDvar("bots_main_waitForHostTime", 15);
    setDvar("sv_maprotation", sv_maprotationString);
	

    level thread spawnBots(botAmount);
}

addGameType(fileName, weighting, minBots, maxBots, botSkill)
{
    newGameType = spawnStruct();
    newGameType.fileName = fileName;
    newGameType.weighting = weighting;
    newGameType.minBots = minBots;
    newGameType.maxBots = maxBots;
    newGameType.botSkill = botSkill;

    return newGameType;
}

selectRandomGametype(gameTypes)
{
    totalWeight = 0;
    foreach (type in gameTypes)
    {
        totalWeight += type.weighting;
    }

    rand = randomInt(totalWeight) + 1;

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

randomBotsAmount(min, max)
{
    rand = randomInt(20);

    if (min == max)
    {
        return min;
    }

    if (min % 2 != 0)
    {
        min++;
    }

    if (max % 2 != 0)
    {
        max--;
    }

    if (rand < 2 && max >= 2)
    {
        return min;
    }
    else if (rand < 8 && max >= 2)
    {
        return 2;
    }
    else if (rand < 14 && max >= 4)
    {
        return 4;
    }
    else if (rand < 18 && max >= 6)
    {
        return 6;
    }
    else
    {
        return max;
    }
}

isHost(player)
{
    return player.name != undefined && !player.isBot;
}

spawnBots(amount)
{
   
	 while(!isHost(level.players[0])){
	
	  wait(7); // Give some time

	//quick check for players
	  playerPool = level.players.size;
	  println("There are "+level.players.size+" Players");
	
if(playerPool>0){
//someone is here..
 if (isHost(level.players[0]))
    {
	  println("Client 0 IS host, rain bots");
	   wait(2);
	     for (i = 0; i < amount; i++)
        {
            addTestClient();  //< i think this is the way...
        }
	  break;
	}else{
	 println("Client 0 IS NOT host");
	// maybe here i should kick bots and redo from start
	}
	}
	}
  

	  println("Bots done!");
	  
}


