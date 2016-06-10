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
    let $playerIndex := xs:integer((($houseIndex - 1) mod 12) div 6) + 1
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
    let $houseInPlayerNodeIndex := xs:integer((($houseIndex - 1) mod 12) mod 6) + 1
    return $houseInPlayerNodeIndex
};



(:~
: This function gets a house's seed count.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to get
: @return seed count of given house
:)
declare function house:getSeedCount($document, $houseIndex) {
    let $playerIndex := house:getPlayerIndexByHouseIndex($houseIndex)
    let $houseInPlayerNodeIndex := house:getHouseInPlayerNodeIndexByHouseIndex($houseIndex)

    let $seedCount := $document/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseInPlayerNodeIndex]/SeedCount
    return $seedCount
};



(:~
: This function sets house's seed count with the given index to zero.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to reset
:)
declare updating function house:increaseSeedCount($document, $houseIndex) {
    house:setSeedCount($document, $houseIndex, house:getSeedCount($document, $houseIndex) + 1)
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
: This function gets a kalah's seed count.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to get
: @return seed count of given kalah
:)
declare function kalah:getSeedCount($document, $kalahIndex) {
    let $seedCount := $document/MancalaGame/Player[$kalahIndex]/PlayersHalf/Kalah/SeedCount
    return $seedCount
};



(:~
: This function increases kalah's seed count with the given index to zero.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to increase
:)
declare updating function kalah:increaseSeedCount($document, $kalahIndex) {
    kalah:setSeedCount($document, $kalahIndex, kalah:getSeedCount($document, $kalahIndex) + 1)
};



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



(:~
: This function moves the seeds, starting at the given house with the given amount of seeds.
: It calls itself recursively.
:
: @param $document XML document
: @param $houseIndex index of the house to start the move on
: @param $seedsToMove amount of seeds to move
:)
declare updating function mancalaGame:moveSeeds($document, $houseIndex, $seedsToMove) {
    let $isNotAtKalah := xs:integer($houseIndex mod 6)
    let $kalahToIncreaseIndex := xs:integer((($houseIndex -1) mod 12) div 6) + 1
    
    return (
        (: check for termination of recursion :)
        if ($seedsToMove > 0)
        then (
            if ($isNotAtKalah = 0)
            then (
                house:increaseSeedCount($document, $houseIndex),
                mancalaGame:moveSeeds($document, $houseIndex + 1, $seedsToMove - 1)
            )
            else (
                (: handle kalah :)
                kalah:increaseSeedCount($document, $kalahToIncreaseIndex),
                if ($seedsToMove > 1)
                then (
                    house:increaseSeedCount($document, $houseIndex),
                    mancalaGame:moveSeeds($document, $houseIndex + 1, $seedsToMove - 2)
                )
                else ()
            )
        )
        else ()
    )
};



(:~
: This function performs a move, starting on the house with the given index.
:
: @param $document XML document
: @param $houseIndex index of the house to start the move on
:)
declare updating function mancalaGame:makeMove($document, $houseIndex) {
    let $startSeedCount := house:getSeedCount($document, $houseIndex)
    
    return (
        (: move seeds :)
        house:resetSeedCount($document, $houseIndex),
        mancalaGame:moveSeeds($document, $houseIndex + 1, $startSeedCount)
        
        (: check for win of seeds :)
        
        (: check for extra move, switch player who is on turn accordingly :)
    )    
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

(: house:getSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"), 1) :)
(: house:setSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"), 1, 1) :)



(: Query calls for class Kalah :)

(: kalah:setSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"), 2, 41) :)



(: Query calls for class MancalaGame :)

(: mancalaGame:getPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
mancalaGame:makeMove(fn:doc("../3_xslt/Game States/Game State 1.xml"), 1)
(: mancalaGame:resetGame(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
(: mancalaGame:switchPlayerOnTurn(fn:doc("../3_xslt/Game States/Game State 1.xml")) :)
