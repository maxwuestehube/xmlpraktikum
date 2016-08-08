(:~
 : This module contains some basic examples for RESTXQ annotations
 : @author BaseX Team
 :)
module namespace page = 'http://basex.org/modules/web-page';

declare namespace house = "house";
declare namespace kalah = "kalah";
declare namespace mancalaGame = "mancalaGame";
declare namespace player = "player";

(:~
 : This function generates the welcome page.
 : @return HTML page
 :)
declare
  %rest:path("")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("-//W3C//DTD XHTML 1.0 Transitional//EN")
  %output:doctype-system("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
  function page:start()
  as element(Q{http://www.w3.org/1999/xhtml}html)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>BaseX HTTP Services</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
    
     <img y="0" x="0" src="static/MancalaSVG.svg" />
     <svg>
             <g id="button_new_game" onclick="startNewGame">
         <desc>a button for starting a new game</desc>
         <rect width="60" height="10" fill="white" stroke="black" stroke-width="1"/>
         <text x="3" y="7" fill="black">Start new Game</text>
      </g>
      
      <g id="button_undo_move">
         <desc>a button for undoing a move</desc>
         <rect x="70" width="45" height="10" fill="white" stroke="black" stroke-width="1"/>
         <text x="73" y="7" fill="black">Undo Move</text>
      </g>
    </svg>
        
    <form action="new_game.html" id="newGame">
     <label for="House">Haus</label>
     <input type="text" id="House"/>
     <button type="new-Game">Neues Spiel</button>
    </form>
    
    <form method="put" action="/">
        <p>Your message:<br />
        <input name="message" size="50"></input>
        <input type="submit" /></p>
      </form>
    </body>
    
  </html>
};



(:~
 : This function returns an XML response message.
 : @param $world  string to be included in the response
 : @return response element 
 :)
declare
  %rest:path("/hello/{$world}")
  %rest:GET
  function page:hello(
    $world as xs:string)
    as element(response)
{
  <response>
    <title>Hello { $world }!</title>
    <time>The current time is: { current-time() }</time>
  </response>
};

(:~
 : This function returns the result of a form request.
 : @param  $message  message to be included in the response
 : @param $agent  user agent string
 : @return response element 
 :)
declare 
  %restxq:path("/")
  %restxq:GET
  %restxq:form-param("message","{$message}", "(no message)")
  %restxq:header-param("User-Agent", "{$agent}")
  function page:hello-postman(
        $message as xs:string,
        $agent  as xs:string*
    )
    as element(response)
{
  <response type='/'>
    <results>
    {
    let $playerIndex := page:house-getPlayerIndexByHouseIndex(1)
    let $houseInPlayerNodeIndex := page:house-getHouseInPlayerNodeIndexByHouseIndex(1)

    let $seedCount := fn:doc("static/Game States/Game State 1.xml")/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseInPlayerNodeIndex]/SeedCount
    
   (::return page:resetGame("static/Game States/Game State 1.xml"):)
   (::return page:kalah-increaseSeedCount("static/Game States/Game State 1.xml", 1):)
  return <rest:forward>
   page:resetGame("static/Game States/Game State 1.xml")
   </rest:forward>
   }</results>
  </response>
};

(:~
: This function gets a house's player node index by the index of the house.
:
: @param $document XML document
: @param $houseIndex index of house which player node index to get
: @return index of player node
:)
declare function page:house-getPlayerIndexByHouseIndex($houseIndex) {
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
declare function page:house-getHouseInPlayerNodeIndexByHouseIndex($houseIndex) {
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
declare function page:house-getSeedCount($document, $houseIndex) {
    let $playerIndex := page:house-getPlayerIndexByHouseIndex($houseIndex)
    let $houseInPlayerNodeIndex := page:house-getHouseInPlayerNodeIndexByHouseIndex($houseIndex)

    let $seedCount := $document/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseInPlayerNodeIndex]/SeedCount
    return $seedCount
};



(:~
: This function sets house's seed count with the given index to zero.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to reset
:)
declare updating function page:house-increaseSeedCount($document, $houseIndex) {
    page:house-setSeedCount($document, $houseIndex, page:house-getSeedCount($document, $houseIndex) + 1)
};



(:~
: This function sets house's seed count with the given index to zero.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to reset
:)
declare updating function page:house-resetSeedCount($document, $houseIndex) {
    page:house-setSeedCount($document, $houseIndex, 0)
};



(:~
: This function sets house's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to set
: @param $seedCount seed count to set
:)
declare updating function page:house-setSeedCount($document, $houseIndex, $seedCount) {
    let $playerIndex := page:house-getPlayerIndexByHouseIndex($houseIndex)
    let $houseInPlayerNodeIndex := page:house-getHouseInPlayerNodeIndexByHouseIndex($houseIndex)

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
declare function page:kalah-getSeedCount($document, $kalahIndex) {
    let $seedCount := $document/MancalaGame/Player[$kalahIndex]/PlayersHalf/Kalah/SeedCount
    return $seedCount
};



(:~
: This function increases kalah's seed count with the given index to zero.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to increase
:)
declare updating function page:kalah-increaseSeedCount($document, $kalahIndex) {
    page:kalah-setSeedCount($document, $kalahIndex, page:kalah-getSeedCount($document, $kalahIndex) + 1)
};



(:~
: This function sets kalah's seed count with the given index to zero.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to reset
:)
declare updating function page:kalah-resetSeedCount($document, $kalahIndex) {
    page:kalah-setSeedCount($document, $kalahIndex, 0)
};



(:~
: This function sets kalah's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to set
: @param $seedCount seed count to set
:)
declare updating function page:kalah-setSeedCount($document, $kalahIndex, $seedCount) {
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
declare function page:getPlayerOnTurn($document) {
    let $playerOnTurn := $document/MancalaGame/PlayerOnTurn
    return $playerOnTurn
};



(:~
: A clean, yet due to the limitations of XQuery not-working recursive version of moving the seeds.
: Updating the same nodes multiple times across the calls originating from one function is forbidden.
: Left in the code to illustrate the limitations of XQuery.
:
: (:~
: : This function moves the seeds, starting at the given house with the given amount of seeds.
: : It calls itself recursively.
: :
: : @param $document XML document
: : @param $houseIndex index of the house to start the move on
: : @param $seedsToMove amount of seeds to move
: :)
: declare updating function mancalaGame:moveSeeds($document, $houseIndex, $seedsToMove) {
:     let $isNotAtKalah := xs:integer($houseIndex mod 6)
:     let $kalahToIncreaseIndex := xs:integer((($houseIndex -1) mod 12) div 6) + 1
:     
:     return (
:         (: check for termination of recursion :)
:         if ($seedsToMove > 0)
:         then (
:             if ($isNotAtKalah = 0)
:             then (
:                 house:increaseSeedCount($document, $houseIndex),
:                 mancalaGame:moveSeeds($document, $houseIndex + 1, $seedsToMove - 1)
:             )
:             else (
:                 (: handle kalah :)
:                 kalah:increaseSeedCount($document, $kalahToIncreaseIndex),
:                 if ($seedsToMove > 1)
:                 then (
:                     house:increaseSeedCount($document, $houseIndex),
:                     mancalaGame:moveSeeds($document, $houseIndex + 1, $seedsToMove - 2)
:                 )
:                 else ()
:             )
:         )
:         else ()
:     )
: };
:
:)



(:~
: This function updates a house with a given index after seeds have been moved after a turn.
:
: @param $document XML document
: @param $houseIndexStartMove index of the house to start the move on
: @param $seedsToMove amount of seeds to move
: @param $houseToUpdate index of the house to update
:)
declare updating function page:updateHouseAfterMovingSeeds($document, $houseIndexStartMove, $seedsToMove, $houseToUpdate) {
    let $fullLaps := xs:integer($seedsToMove div 14)
    let $finalPosition := $houseIndexStartMove + $seedsToMove
    
    return (
        if (($houseIndexStartMove < $houseToUpdate) and (($finalPosition - xs:integer(($finalPosition + 1) div 7)) >= $houseToUpdate))
        then (
            if ($houseIndexStartMove = $houseToUpdate)
            then page:house-setSeedCount($document, $houseToUpdate, $fullLaps + 1)
            else page:house-setSeedCount($document, $houseToUpdate, page:house-getSeedCount($document, $houseToUpdate) + $fullLaps + 1)
        )
        else (
            if ($houseIndexStartMove = $houseToUpdate)
            then page:house-setSeedCount($document, $houseToUpdate, $fullLaps)
            else page:house-setSeedCount($document, $houseToUpdate, page:house-getSeedCount($document, $houseToUpdate) + $fullLaps)
        )   
    )
};



(:~
: This function updates a kalah with a given index after seeds have been moved after a turn.
:
: @param $document XML document
: @param $houseIndexStartMove index of the house to start the move on
: @param $seedsToMove amount of seeds to move
: @param $kalahToUpdate index of the kalah to update
:)
declare updating function page:updateKalahAfterMovingSeeds($document, $houseIndexStartMove, $seedsToMove, $kalahToUpdate) {
    let $fullLaps := xs:integer($seedsToMove div 14)
    let $finalPosition := $houseIndexStartMove + $seedsToMove
    
    return (
        if (($houseIndexStartMove < (21 -$kalahToUpdate * 7)) and (($finalPosition - xs:integer($finalPosition div 7) + 2) >= (21 - $kalahToUpdate * 7)))
        then page:kalah-setSeedCount($document, $kalahToUpdate, page:kalah-getSeedCount($document, $kalahToUpdate) + $fullLaps + 1)
        else page:kalah-setSeedCount($document, $kalahToUpdate, page:kalah-getSeedCount($document, $kalahToUpdate) + $fullLaps)
    )
};



(:~
: This function moves the seeds, starting at the given house with the given amount of seeds.
: It calls itself recursively.
:
: @param $document XML document
: @param $houseIndex index of the house to start the move on
: @param $seedsToMove amount of seeds to move
:)
declare updating function page:moveSeeds($document, $houseIndex, $seedsToMove) {
    let $fullLaps := xs:integer($seedsToMove div 14)
    let $finalPosition := $houseIndex + $seedsToMove
    
    return (
        (: houses :)
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 1),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 2),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 3),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 4),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 5),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 6),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 7),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 8),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 9),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 10),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 11),
        page:updateHouseAfterMovingSeeds($document, $houseIndex, $seedsToMove, 12),
        
        (: kalahs :)
        page:updateKalahAfterMovingSeeds($document, $houseIndex, $seedsToMove, 1),
        page:updateKalahAfterMovingSeeds($document, $houseIndex, $seedsToMove, 2)
    )
};



(:~
: This function performs a move, starting on the house with the given index.
:
: @param $document XML document
: @param $houseIndex index of the house to start the move on
:)
declare updating function page:makeMove($document, $houseIndex) {
    let $startSeedCount := page:house-getSeedCount($document, $houseIndex)
    
    return (
        (: move seeds :)
        page:moveSeeds($document, $houseIndex, $startSeedCount)
        
        (: check for win of seeds :)
        (: TODO :)
        
        (: check for extra move, switch player who is on turn accordingly :)
        (: TODO :)
    )    
};



(:~
: This function sets the given player's win count to zero.
:
: @param $player player node which win count should be set to zero
:)
declare updating function page:resetPlayersWinCount($player) {
    replace value of node $player/WinCount with 0
};



(:~
: This function resets the win counts, kalah's and house's seed counts.
:
: @param $document XML document
:)
declare updating function page:resetGame($document) {
    for $player in $document/MancalaGame/Player
    
    return (
        page:resetPlayersWinCount($player),
        page:kalah-resetSeedCount($document, page:player-getIndexByName($document, $player/Name)),
        page:resetSeedCountsOfPlayer($document, page:player-getIndexByName($document, $player/Name))
    )
};



(:~
: This function resets the seed counts of the houses of a given player
:
: @param $document XML document
: @param $playerIndex index of player which houses' seeds counts to reset
:)
declare updating function page:resetSeedCountsOfPlayer($document, $playerIndex) {
    let $offset := ($playerIndex - 1) * 6
    
    return (
        page:house-resetSeedCount($document, $offset + 1),
        page:house-resetSeedCount($document, $offset + 2),
        page:house-resetSeedCount($document, $offset + 3),
        page:house-resetSeedCount($document, $offset + 4),
        page:house-resetSeedCount($document, $offset + 5),
        page:house-resetSeedCount($document, $offset + 6)
    )
};



(:~
: This function switches the player which is on turn in the PlayerOnTurn node.
:
: @param $document XML document
:)
declare updating function page:switchPlayerOnTurn($document) {
    let $firstPlayerName := page:player-getName($document, 1)
    let $secondPlayerName := page:player-getName($document, 2)
    let $playerOnTurn := page:getPlayerOnTurn($document)
    
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
declare function page:player-getIndexByName($document, $playerName) {
    let $firstPlayerName := page:player-getName($document, 1)
    let $secondPlayerName := page:player-getName($document, 2)

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
declare function page:player-getName($document, $playerIndex) {
    let $playerName := $document/MancalaGame/Player[$playerIndex]/Name
    return $playerName
};
