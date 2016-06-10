(: only used namespace, paths in files are declared in functions :)
declare namespace local="local";



(: returns the player on turn
   $this: XML document :)
declare function local:getPlayerOnTurn($this) {
    for $playerOnTurn in $this/MancalaGame/PlayerOnTurn
    return $playerOnTurn
};



(: sets the given player's win count to zero
   $player: player node which win count should be set to zero :)
declare updating function local:resetPlayersWinCount($player) {
    replace value of node $player/WinCount with 0
};

(: sets the given player's kalah's seed count to zero
   $player: player node which kalah's seed count should be set to zero :)
declare updating function local:resetPlayersKalahsSeedCounts($player) {
    for $kalah in $player/PlayersHalf/Kalah
    return replace value of node $kalah/SeedCount with 0
};

(: sets the given player's house's seed count to zero
   $player: player node which house's seed count should be set to zero :)
declare updating function local:resetPlayersHousesSeedCounts($player) {
    for $house in $player/PlayersHalf/House
    return replace value of node $house/SeedCount with 0
};

(: returns the win counts, kalah's and house's seed counts
   $this: XML document :)
declare updating function local:resetGame($this) {
    for $player in $this/MancalaGame/Player
    return (
        local:resetPlayersWinCount($player),
        local:resetPlayersKalahsSeedCounts($player),
        local:resetPlayersHousesSeedCounts($player)
    )
};



(: query calls, only one call is active at the same time :)
(: local:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
local:resetGame(fn:doc("../3_xslt/Game States/Game State 1.xml"))
