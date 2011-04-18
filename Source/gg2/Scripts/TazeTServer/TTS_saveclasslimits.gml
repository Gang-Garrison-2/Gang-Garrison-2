/*
Saves class limit settings
*/
ini_open("tts.ini");
ini_write_real("Classlimits","Runner",global.TTSClassLimits[CLASS_SCOUT]);
ini_write_real("Classlimits","Rocketman",global.TTSClassLimits[CLASS_SOLDIER]);
ini_write_real("Classlimits","Rifleman",global.TTSClassLimits[CLASS_SNIPER]);
ini_write_real("Classlimits","Detonator",global.TTSClassLimits[CLASS_DEMOMAN]);
ini_write_real("Classlimits","Healer",global.TTSClassLimits[CLASS_MEDIC]);
ini_write_real("Classlimits","Constructor",global.TTSClassLimits[CLASS_ENGINEER]);
ini_write_real("Classlimits","Overweight",global.TTSClassLimits[CLASS_HEAVY]);
ini_write_real("Classlimits","Infiltrator",global.TTSClassLimits[CLASS_SPY]);
ini_write_real("Classlimits","Firebug",global.TTSClassLimits[CLASS_PYRO]);
ini_write_real("Classlimits","Secret",global.TTSClassLimits[CLASS_QUOTE]);
ini_close();
