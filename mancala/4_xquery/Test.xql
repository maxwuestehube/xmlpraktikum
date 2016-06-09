declare namespace local="local";
declare namespace players = "MancalaGame:Player";



declare function local:getAllPlayersWithWinCountGreaterZero($this)
{
    for $x in $this/MancalaGame/Player
    where $x/WinCount>0
    return $x/Name
};

local:getAllPlayersWithWinCountGreaterZero(fn:doc("..\3_xslt\Game States\Game State 1.xml"))