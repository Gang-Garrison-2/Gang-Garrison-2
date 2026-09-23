global.damageSourceIcons = ds_list_create();

// Declared statically: createGlobalDamageSource built these globals from strings
// with execute_string, which ENIGMA can't run. The order sets the IDs sent over
// the network, so keep it.
globalvar DAMAGE_SOURCE_NEEDLEGUN, DAMAGE_SOURCE_RIFLE, DAMAGE_SOURCE_RIFLE_CHARGED,
    DAMAGE_SOURCE_MINEGUN, DAMAGE_SOURCE_MINIGUN, DAMAGE_SOURCE_FLAMETHROWER,
    DAMAGE_SOURCE_SCATTERGUN, DAMAGE_SOURCE_SHOTGUN, DAMAGE_SOURCE_ROCKETLAUNCHER,
    DAMAGE_SOURCE_REVOLVER, DAMAGE_SOURCE_SENTRYTURRET, DAMAGE_SOURCE_BLADE, DAMAGE_SOURCE_BUBBLE,
    DAMAGE_SOURCE_REFLECTED_ROCKET, DAMAGE_SOURCE_REFLECTED_STICKY, DAMAGE_SOURCE_KNIFE,
    DAMAGE_SOURCE_BACKSTAB, DAMAGE_SOURCE_FLARE, DAMAGE_SOURCE_REFLECTED_FLARE,
    DAMAGE_SOURCE_KILL_BOX, DAMAGE_SOURCE_FRAG_BOX, DAMAGE_SOURCE_PITFALL,
    DAMAGE_SOURCE_FINISHED_OFF, DAMAGE_SOURCE_FINISHED_OFF_GIB, DAMAGE_SOURCE_BID_FAREWELL,
    DAMAGE_SOURCE_GENERATOR_EXPLOSION;

DAMAGE_SOURCE_NEEDLEGUN =           createDamageSource(NeedleKL);
DAMAGE_SOURCE_RIFLE =               createDamageSource(RifleKL);
DAMAGE_SOURCE_RIFLE_CHARGED =       createDamageSource(RifleChargedKL);
DAMAGE_SOURCE_MINEGUN =             createDamageSource(MineKL);
DAMAGE_SOURCE_MINIGUN =             createDamageSource(MinigunKL);
DAMAGE_SOURCE_FLAMETHROWER =        createDamageSource(FlameKL);
DAMAGE_SOURCE_SCATTERGUN =          createDamageSource(ScatterKL);
DAMAGE_SOURCE_SHOTGUN =             createDamageSource(ShotgunKL);
DAMAGE_SOURCE_ROCKETLAUNCHER =      createDamageSource(RocketKL);
DAMAGE_SOURCE_REVOLVER =            createDamageSource(RevolverKL);
DAMAGE_SOURCE_SENTRYTURRET =        createDamageSource(TurretKL);
DAMAGE_SOURCE_BLADE =               createDamageSource(BladeKL);
DAMAGE_SOURCE_BUBBLE =              createDamageSource(BubbleKL);
DAMAGE_SOURCE_REFLECTED_ROCKET =    createDamageSource(RocketReflectKL);
DAMAGE_SOURCE_REFLECTED_STICKY =    createDamageSource(MineReflectKL);
DAMAGE_SOURCE_KNIFE =               createDamageSource(KnifeKL);
DAMAGE_SOURCE_BACKSTAB =            createDamageSource(BackstabKL);
DAMAGE_SOURCE_FLARE =               createDamageSource(FlareKL);
DAMAGE_SOURCE_REFLECTED_FLARE =     createDamageSource(FlareReflectKL);
DAMAGE_SOURCE_KILL_BOX =            createDamageSource(DeadKL);
DAMAGE_SOURCE_FRAG_BOX =            createDamageSource(DeadKL);
DAMAGE_SOURCE_PITFALL =             createDamageSource(DeadKL);
DAMAGE_SOURCE_FINISHED_OFF =        createDamageSource(DeadKL);
DAMAGE_SOURCE_FINISHED_OFF_GIB =    createDamageSource(DeadKL);
DAMAGE_SOURCE_BID_FAREWELL =        createDamageSource(DeadKL);
DAMAGE_SOURCE_GENERATOR_EXPLOSION = createDamageSource(ExplodeKL);
