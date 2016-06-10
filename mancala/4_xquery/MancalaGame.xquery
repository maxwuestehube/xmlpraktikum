(:~
: This file contains the declarations of functions of the class MancalaGame.
: @author Max Wuestehube
:)

declare namespace mancalaGame="local";





(:~
: This function returns the player on turn.
:
: @param $document XML document
: @return a PlayerOnTurn element
:)
declare function mancalaGame:getPlayerOnTurn($document) {
    let $playerOnTurn := $document/MancalaGame/PlayerOnTurn
    return $playerOnTurn
};



(:~
: This function sets the given player's win count to zero.
:
: @param $player player node which win count should be set to zero
:)
declare updating function mancalaGame:resetPlayersWinCount($player) {
    replace value of node $player/WinCount with 0
};



(:~
: This function sets the given player's kalah's seed count to zero.
:
: @param $player player node which kalah's seed count should be set to zero
:)
declare updating function mancalaGame:resetPlayersKalahsSeedCounts($player) {
    for $kalah in $player/PlayersHalf/Kalah
    return replace value of node $kalah/SeedCount with 0
};



(:~
: This function sets the given player's house's seed count to zero.
:
: @param $player player node which house's seed count should be set to zero
:)
declare updating function mancalaGame:resetPlayersHousesSeedCounts($player) {
    for $house in $player/PlayersHalf/House
    
    return replace value of node $house/SeedCount with 0
};



(:~
: This function resets the win counts, kalah's and house's seed counts.
:
: @param $document XML document
:)
declare updating function mancalaGame:resetGame($document) {
    for $player in $document/MancalaGame/Player
    
    return (
        mancalaGame:resetPlayersWinCount($player),
        mancalaGame:resetPlayersKalahsSeedCounts($player),
        mancalaGame:resetPlayersHousesSeedCounts($player)
    )
};



(:~
: This function returns the name of the player with the given player index.
:
: @param $document XML document
: @param $playerIndex index of the player which name should be returned
: @return name of the player with the given index
:)
declare function mancalaGame:getPlayerName($document, $playerIndex) {
    let $playerName := $document/MancalaGame/Player[$playerIndex]/Name
    return $playerName
};



(:~
: This function switches the player which is on turn in the PlayerOnTurn node.
:
: @param $document XML document
:)
declare updating function mancalaGame:switchPlayerOnTurn($document) {
    let $firstPlayerName := mancalaGame:getPlayerName($document, 1)
    let $secondPlayerName := mancalaGame:getPlayerName($document, 2)
    let $playerOnTurn := mancalaGame:getPlayerOnTurn($document)
    
    return (
        if ($playerOnTurn = $firstPlayerName)
        then replace value of node $playerOnTurn with $secondPlayerName
        else replace value of node $playerOnTurn with $firstPlayerName
    )
};





(: query calls, only one call is active at once :)

(: mancalaGame:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
(: mancalaGame:resetGame(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
mancalaGame:switchPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml"))
