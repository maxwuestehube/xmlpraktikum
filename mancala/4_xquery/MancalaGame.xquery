(: only used namespace, paths in files are declared in functions :)
declare namespace local="local";



(: returns the player on turn
   $this: XML document :)
declare function local:getPlayerOnTurn($this)
{
    for $x in $this/MancalaGame/PlayerOnTurn
    return $x
};



(: query calls, only one call is active at the same time :)
local:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml"))