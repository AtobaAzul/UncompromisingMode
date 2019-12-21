-----------------------------------------------------------------
-- WX damage changes during wet
-----------------------------------------------------------------
--GLOBAL.TUNING.WX78_MIN_MOISTURE_DAMAGE= -.1 * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE, --Not even used in the code by Klei
GLOBAL.TUNING.WX78_MAX_MOISTURE_DAMAGE = (-0.5) * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE
GLOBAL.TUNING.WX78_MOISTURE_DRYING_DAMAGE = (-0.3) * GLOBAL.TUNING.DSTU.WX78_MOISTURE_DAMAGE_INCREASE

--TODO, reimplement dorainsparks to do based on wetness from min to max damage
    --add rate too