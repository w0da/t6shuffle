# t6shuffle
Simple script for shuffling t6 games, maps and bots

Place shufflegames.gsc into your scripts folder : t6/storage/mp

in the section looking like this:
 
    // Add game types -> change to suit your games
	
    gameTypes[gameTypes.size] = addGameType("hc_dm.cfg", 8, 0, 6, 2);
    gameTypes[gameTypes.size] = addGameType("hc_tdm.cfg", 8, 0, 6, 2);
    ....

    just add your gametpytes which match your game settings, and add a number for how often you want it to appear, along with a minimum and maximum bot setting.

    you can also change the skill of the bots here.

    thats pretty much it

    enjoy, open to improvemnts :)

