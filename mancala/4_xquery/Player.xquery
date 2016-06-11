declare namespace player="player";

declare updating function player:IncreaseWinCount($this){
    for $x in $this/MancalaGame/Player
    where $x/Name = $this/MancalaGame/PlayerOnTurn
    return player:UpdateWinCount($x)
};

declare updating function player:UpdateWinCount($this){
    replace value of node $this/WinCount with $this/WinCount +1
};

(: restliche methoden siehe klassendiagramm:)

declare updating function player:ResetWinCount($this){
    for $x in $this/MancalaGame/Player  
    return player:ZeroWinCount($x)
};

declare updating function player:ZeroWinCount($this){
    replace value of node $this/WinCount with 0
};

declare function player:getName($this){
    for $x in $this/MancalaGame/Player  
    return $x/Name
};

declare function player:getWinCount($this){
    for $x in $this/MancalaGame/Player  
    return $x/WinCount
};

declare function player:getSeedCount($this){
    for $x in $this/MancalaGame/Player  
    return player:CountSeeds($x)
};

declare function player:CountSeeds($this){
    let $seedCount := $this/PlayersHalf/Kalah/SeedCount + fn:sum($this/PlayersHalf/House/SeedCount)
    return $seedCount
};

player:getName(fn:doc("..\3_xslt\Game States\Game State 1.xml"))