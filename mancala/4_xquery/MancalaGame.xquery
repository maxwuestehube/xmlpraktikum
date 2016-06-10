(:~
: This file contains the declarations of functions of the class MancalaGame.
: @author Alexandra Brandner, Meryem Oezkaya, Max Wuestehube
:)



(: namespace declarations :)
declare namespace house = "house";
declare namespace kalah = "kalah";
declare namespace mancalaGame = "mancalaGame";
declare namespace player = "player";





(:-----------------------------------------------------------------------------------------------:)





(:~
: This section contains functions of the class Kalah.
:)



(:~
: This function gets a house's player node index by the index of the house.
:
: @param $document XML document
: @param $houseIndex index of house which player node index to get
: @return index of player node
:)
declare function house:getPlayerIndexByHouseIndex($houseIndex) {
    let $playerIndex := xs:integer(($houseIndex - 1) div 6) + 1
    return $playerIndex
};



(:~
: This function gets a house's node index in the player node by the house index.
:
: @param $document XML document
: @param $houseIndex index of house which node index in the player node to get
: @return index of house in player node
:)
declare function house:getHouseInPlayerNodeIndexByHouseIndex($houseIndex) {
    let $houseInPlayerNodeIndex := xs:integer(($houseIndex - 1) mod 6) + 1
    return $houseInPlayerNodeIndex
};



(:~
: This function sets house's seed count with the given index to zero.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to reset
:)
declare updating function house:resetSeedCount($document, $houseIndex) {
    house:setSeedCount($document, $houseIndex, 0)
};



(:~
: This function sets house's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to set
: @param $seedCount seed count to set
:)
declare updating function house:setSeedCount($document, $houseIndex, $seedCount) {
    let $playerIndex := house:getPlayerIndexByHouseIndex($houseIndex)
    let $houseInPlayerNodeIndex := house:getHouseInPlayerNodeIndexByHouseIndex($houseIndex)

    return (
        replace value of node $document/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseInPlayerNodeIndex]/SeedCount with $seedCount
    )
};





(:-----------------------------------------------------------------------------------------------:)





(:~
: This section contains functions of the class Kalah.
:)



(:~
: This function sets kalah's seed count with the given index to zero.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to reset
:)
declare updating function kalah:resetSeedCount($document, $kalahIndex) {
    kalah:setSeedCount($document, $kalahIndex, 0)
};



(:~
: This function sets kalah's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to set
: @param $seedCount seed count to set
:)
declare updating function kalah:setSeedCount($document, $kalahIndex, $seedCount) {
    replace value of node $document/MancalaGame/Player[$kalahIndex]/PlayersHalf/Kalah/SeedCount with $seedCount
};




(:-----------------------------------------------------------------------------------------------:)





(:~
: This section contains functions of the class ManacalaGame.
:)



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



declare function mancalaGame:makeMove($document, $houseIndex) {
    (: move seeds :)
    let $x := 1
    return (
        $x
    )
    
    (: check for win of seeds :)
    
    (: check for extra move :)
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
: This function resets the win counts, kalah's and house's seed counts.
:
: @param $document XML document
:)
declare updating function mancalaGame:resetGame($document) {
    for $player in $document/MancalaGame/Player
    
    return (
        mancalaGame:resetPlayersWinCount($player),
        kalah:resetSeedCount($document, player:getIndexByName($document, $player/Name)),
        mancalaGame:resetSeedCountsOfPlayer($document, player:getIndexByName($document, $player/Name))
    )
};



(:~
: This function resets the seed counts of the houses of a given player
:
: @param $document XML document
: @param $playerIndex index of player which houses' seeds counts to reset
:)
declare updating function mancalaGame:resetSeedCountsOfPlayer($document, $playerIndex) {
    let $offset := ($playerIndex - 1) * 6
    
    return (
        house:resetSeedCount($document, $offset + 1),
        house:resetSeedCount($document, $offset + 2),
        house:resetSeedCount($document, $offset + 3),
        house:resetSeedCount($document, $offset + 4),
        house:resetSeedCount($document, $offset + 5),
        house:resetSeedCount($document, $offset + 6)
    )
};



(:~
: This function switches the player which is on turn in the PlayerOnTurn node.
:
: @param $document XML document
:)
declare updating function mancalaGame:switchPlayerOnTurn($document) {
    let $firstPlayerName := player:getName($document, 1)
    let $secondPlayerName := player:getName($document, 2)
    let $playerOnTurn := mancalaGame:getPlayerOnTurn($document)
    
    return (
        if ($playerOnTurn = $firstPlayerName)
        then replace value of node $playerOnTurn with $secondPlayerName
        else replace value of node $playerOnTurn with $firstPlayerName
    )
};





(:-----------------------------------------------------------------------------------------------:)





(:~
: This section contains functions of the class Player.
:)



(:~
: This function returns the index of the player with the given name.
:
: @param $document XML document
: @param $playerName name of player which index should be returned
: @return index of player with the given name
:)
declare function player:getIndexByName($document, $playerName) {
    let $firstPlayerName := player:getName($document, 1)
    let $secondPlayerName := player:getName($document, 2)

    return (
        if ($playerName = $firstPlayerName)
        then 1
        else 2
    )
};



(:~
: This function returns the name of the player with the given player index.
:
: @param $document XML document
: @param $playerIndex index of the player which name should be returned
: @return name of the player with the given index
:)
declare function player:getName($document, $playerIndex) {
    let $playerName := $document/MancalaGame/Player[$playerIndex]/Name
    return $playerName
};





(:-----------------------------------------------------------------------------------------------:)





(:~
: This section contains the query calls.
: Only one call is active at once.
:)



(: Query calls for class House :)

(: house:setSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"), 1, 1) :)



(: Query calls for class Kalah :)

(: kalah:setSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"), 2, 41) :)



(: Query calls for class MancalaGame :)

(: mancalaGame:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
(: mancalaGame:makeMove(fn:doc("../3_xslt/Game States/Game State 1.xml"), 1) :)
mancalaGame:resetGame(fn:doc("../3_xslt/Game States/Game State 1.xml"))
(: mancalaGame:switchPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
