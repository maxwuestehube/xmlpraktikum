(: only used namespace, node paths are declared in functions :)
declare namespace mancalaGame="local";



(: returns the player on turn
   $this: XML document :)
declare function mancalaGame:getPlayerOnTurn($document) {
    for $playerOnTurn in $document/MancalaGame/PlayerOnTurn
    return $playerOnTurn
};



(: sets the given player's win count to zero
   $player: player node which win count should be set to zero :)
declare updating function mancalaGame:resetPlayersWinCount($player) {
    replace value of node $player/WinCount with 0
};

(: sets the given player's kalah's seed count to zero
   $player: player node which kalah's seed count should be set to zero :)
declare updating function mancalaGame:resetPlayersKalahsSeedCounts($player) {
    for $kalah in $player/PlayersHalf/Kalah
    return replace value of node $kalah/SeedCount with 0
};

(: sets the given player's house's seed count to zero
   $player: player node which house's seed count should be set to zero :)
declare updating function mancalaGame:resetPlayersHousesSeedCounts($player) {
    for $house in $player/PlayersHalf/House
    return replace value of node $house/SeedCount with 0
};

(: returns the win counts, kalah's and house's seed counts
   $this: XML document :)
declare updating function mancalaGame:resetGame($document) {
    for $player in $document/MancalaGame/Player
    return (
        mancalaGame:resetPlayersWinCount($player),
        mancalaGame:resetPlayersKalahsSeedCounts($player),
        mancalaGame:resetPlayersHousesSeedCounts($player)
    )
};

(: declare updating function mancalaGame:switchPlayerOnTurn($document) {

}: :)



(: query calls, only one call is active at the same time :)
(: mancalaGame:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
mancalaGame:resetGame(fn:doc("../3_xslt/Game States/Game State 1.xml"))
