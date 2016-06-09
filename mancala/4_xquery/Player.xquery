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

player:IncreaseWinCount(fn:doc("..\3_xslt\Game States\Game State 1.xml"))