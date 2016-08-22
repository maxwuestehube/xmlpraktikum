(:~
 : This module contains some basic examples for RESTXQ annotations
 : @author BaseX Team
 :)
module namespace page = 'http://basex.org/modules/web-page';

declare namespace db = 'http://basex.org/modules/db';

declare namespace house = "house";
declare namespace kalah = "kalah";
declare namespace mancalaGame = "mancalaGame";
declare namespace player = "player";

declare variable $ page:testvar := 5;

declare variable $ page:testvar2 := fn:doc("static/Game States/Game State 1.xml");

(:~
 : This function generates the welcome page.
 : @return HTML page
 :)
declare 
  %rest:path("")
  function page:start()
  as element(Q{http://www.w3.org/1999/xhtml}html)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>BaseX HTTP Services</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
    
     <svg>
     <img y="0" x="0" src="static/MancalaSVG.svg" height="400" width="600"/>
     </svg>
        
    <form action="new_game.html" id="newGame">
     <label for="House">Haus</label>
     <input type="text" id="House"/>
     <button type="new-Game">Neues Spiel</button>
    </form>
    
    <form method="put" action="/test">
        <p>TEST:<br />
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
  %rest:path("/test")
  %rest:GET
  function page:test-game(
    )
{

   let $document := fn:doc("static/Game States/Game State 1.xml")
   (:return page:resetGame():)
 
     (:page:svg($page:testvar2):)
   return page:replaceTest() 
  

};

declare function page:replaceTest(){
 let $document := fn:doc("webapp/Game State 1.xml")
 let $test := %updating function($document){replace value of node $document/MancalaGame/Player[1]/WinCount with ($document/MancalaGame/Player[1]/WinCount+1)}
 let $y := file:write-text("webapp/Game State 1.xml", $document update(updating $test(.)))
 return page:svg(fn:doc("webapp/Game State 1.xml"))
};

declare
function page:svg($document){
    let $seedCount := $document/MancalaGame/Player[1]/PlayersHalf/Kalah/SeedCount/text()


    let $page:testvar := $page:testvar +1
    let $winCount1 := $page:testvar (: $document/MancalaGame/Player[1]/WinCount/text()    :)
 
    return 
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>BaseX HTTP Services</title>
      <link rel="stylesheet" type="text/css" href="static/style.css"/>
    </head>
    <body>
    
     <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="400" width="600">
   <desc>a Kalaha game</desc>
   <defs>
      <g id="house">
         <desc>a so-called Kalaha "house"</desc>
         <rect width="45" height="85" fill="white" stroke="black" stroke-width="2"/>
      </g>
      <g id="kalah">
         <desc>a so-called Kalaha "Kalah"</desc>
         <circle r="40" stroke="black" stroke-width="2,5" fill="white"/>
      </g>
      <g id="seed">
         <desc>a so-called Kalaha "seed"</desc>
         <circle r="4" stroke="#00A4DE" stroke-width="2,5" fill="#00A4DE"/>
      </g>
      <g id="board">
         <desc>the actual Kalaha board, presented in traditional layout</desc>
         <path d="M0 40 Q 0 0 40 0                         L 535 0                         M535 0 Q 575 0 575 40                         L 575 195                         M575 195 Q 575 235 535 235                         L 40 235                         M40 235 Q 0 235 0 195                         L 0 40" stroke="black" stroke-width="2,5" fill="#E8F9FF"/>
         <use xlink:href="#kalah" x="60" y="120"/>
         <use xlink:href="#house" x="115" y="20"/>
         <use xlink:href="#house" x="175" y="20"/>
         <use xlink:href="#house" x="235" y="20"/>
         <use xlink:href="#house" x="295" y="20"/>
         <use xlink:href="#house" x="355" y="20"/>
         <use xlink:href="#house" x="415" y="20"/>
         <use xlink:href="#kalah" x="515" y="120"/>
         <use xlink:href="#house" x="115" y="130"/>
         <use xlink:href="#house" x="175" y="130"/>
         <use xlink:href="#house" x="235" y="130"/>
         <use xlink:href="#house" x="295" y="130"/>
         <use xlink:href="#house" x="355" y="130"/>
         <use xlink:href="#house" x="415" y="130"/>
         <text x="25" y="175" fill="black">Player1</text>
         <text x="25" y="105" fill="black">10</text>
         <use xlink:href="#seed" x="48" y="135"/>
         <use xlink:href="#seed" x="38" y="132.5"/>
         <use xlink:href="#seed" x="28" y="130"/>
         <use xlink:href="#seed" x="58" y="127.5"/>
         <use xlink:href="#seed" x="48" y="125"/>
         <use xlink:href="#seed" x="38" y="122.5"/>
         <use xlink:href="#seed" x="28" y="120"/>
         <use xlink:href="#seed" x="58" y="117.5"/>
         <use xlink:href="#seed" x="48" y="115"/>
         <use xlink:href="#seed" x="38" y="112.5"/>
         <text x="0" y="250" fill="black">Anzahl Gewinne: {$winCount1}</text>
         <text x="0" y="275" fill="black">Anzahl Samen: {$seedCount}</text>
         <text x="490" y="175" fill="black">Player2</text>
         <text x="490" y="105" fill="black">8</text>
         <use xlink:href="#seed" x="493" y="130"/>
         <use xlink:href="#seed" x="523" y="127.5"/>
         <use xlink:href="#seed" x="513" y="125"/>
         <use xlink:href="#seed" x="503" y="122.5"/>
         <use xlink:href="#seed" x="493" y="120"/>
         <use xlink:href="#seed" x="523" y="117.5"/>
         <use xlink:href="#seed" x="513" y="115"/>
         <use xlink:href="#seed" x="503" y="112.5"/>
         <text x="465" y="250" fill="black">Anzahl Gewinne: 2</text>
         <text x="465" y="275" fill="black">Anzahl Samen: 1</text>
         <text x="120" y="35" fill="black">2</text>
         <use xlink:href="#seed" x="143" y="45"/>
         <use xlink:href="#seed" x="133" y="42.5"/>
         <text x="180" y="35" fill="black">3</text>
         <use xlink:href="#seed" x="213" y="47.5"/>
         <use xlink:href="#seed" x="203" y="45"/>
         <use xlink:href="#seed" x="193" y="42.5"/>
         <text x="240" y="35" fill="black">4</text>
         <use xlink:href="#seed" x="243" y="50"/>
         <use xlink:href="#seed" x="273" y="47.5"/>
         <use xlink:href="#seed" x="263" y="45"/>
         <use xlink:href="#seed" x="253" y="42.5"/>
         <text x="300" y="35" fill="black">1</text>
         <use xlink:href="#seed" x="313" y="42.5"/>
         <text x="360" y="35" fill="black">6</text>
         <use xlink:href="#seed" x="383" y="55"/>
         <use xlink:href="#seed" x="373" y="52.5"/>
         <use xlink:href="#seed" x="363" y="50"/>
         <use xlink:href="#seed" x="393" y="47.5"/>
         <use xlink:href="#seed" x="383" y="45"/>
         <use xlink:href="#seed" x="373" y="42.5"/>
         <text x="420" y="35" fill="black">8</text>
         <use xlink:href="#seed" x="423" y="60"/>
         <use xlink:href="#seed" x="453" y="57.5"/>
         <use xlink:href="#seed" x="443" y="55"/>
         <use xlink:href="#seed" x="433" y="52.5"/>
         <use xlink:href="#seed" x="423" y="50"/>
         <use xlink:href="#seed" x="453" y="47.5"/>
         <use xlink:href="#seed" x="443" y="45"/>
         <use xlink:href="#seed" x="433" y="42.5"/>
         <text x="120" y="145" fill="black">8</text>
         <use xlink:href="#seed" x="123" y="170"/>
         <use xlink:href="#seed" x="153" y="167.5"/>
         <use xlink:href="#seed" x="143" y="165"/>
         <use xlink:href="#seed" x="133" y="162.5"/>
         <use xlink:href="#seed" x="123" y="160"/>
         <use xlink:href="#seed" x="153" y="157.5"/>
         <use xlink:href="#seed" x="143" y="155"/>
         <use xlink:href="#seed" x="133" y="152.5"/>
         <text x="180" y="145" fill="black">10</text>
         <use xlink:href="#seed" x="203" y="175"/>
         <use xlink:href="#seed" x="193" y="172.5"/>
         <use xlink:href="#seed" x="183" y="170"/>
         <use xlink:href="#seed" x="213" y="167.5"/>
         <use xlink:href="#seed" x="203" y="165"/>
         <use xlink:href="#seed" x="193" y="162.5"/>
         <use xlink:href="#seed" x="183" y="160"/>
         <use xlink:href="#seed" x="213" y="157.5"/>
         <use xlink:href="#seed" x="203" y="155"/>
         <use xlink:href="#seed" x="193" y="152.5"/>
         <text x="240" y="145" fill="black">4</text>
         <use xlink:href="#seed" x="243" y="160"/>
         <use xlink:href="#seed" x="273" y="157.5"/>
         <use xlink:href="#seed" x="263" y="155"/>
         <use xlink:href="#seed" x="253" y="152.5"/>
         <text x="300" y="145" fill="black">1</text>
         <use xlink:href="#seed" x="313" y="152.5"/>
         <text x="360" y="145" fill="black">3</text>
         <use xlink:href="#seed" x="393" y="157.5"/>
         <use xlink:href="#seed" x="383" y="155"/>
         <use xlink:href="#seed" x="373" y="152.5"/>
         <text x="420" y="145" fill="black">1</text>
         <use xlink:href="#seed" x="433" y="152.5"/>
         <text x="200" y="305" fill="black">Spieler am Zug: Player1</text>
      </g>
      <g id="logo">
         <desc>a logo</desc>
         <text x="10" y="25" fill="black">Kalaha</text>
      </g>
   </defs>
   <use xlink:href="#logo" x="0" y="0"/>
   <use xlink:href="#button_new_game" x="0" y="40"/>
   <use xlink:href="#button_undo_move" x="145" y="40"/>
   <use xlink:href="#board" x="0" y="90"/>
</svg>

        
    <form action="new_game.html" id="newGame">
     <label for="House">Haus</label>
     <input type="text" id="House"/>
     <button type="new-Game">Neues Spiel</button>
    </form>
    
    <form method="put" action="/test">
        <p>TEST:<br />
        <input type="submit" /></p>
      </form>
    </body>
    
  </html>
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
declare %updating function page:house-increaseSeedCount($document, $houseIndex) {
    page:house-setSeedCount($document, $houseIndex, page:house-getSeedCount($document, $houseIndex) + 1)
};



(:~
: This function sets house's seed count with the given index to zero.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to reset
:)
declare %updating function page:house-resetSeedCount($document, $houseIndex) {
    page:house-setSeedCount($document, $houseIndex, 0)
};



(:~
: This function sets house's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $houseIndex index of house which seed count to set
: @param $seedCount seed count to set
:)
declare %updating function page:house-setSeedCount($document, $houseIndex, $seedCount) {
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
declare %updating function page:kalah-increaseSeedCount($document, $kalahIndex) {
    page:kalah-setSeedCount($document, $kalahIndex, page:kalah-getSeedCount($document, $kalahIndex) + 1)
};



(:~
: This function sets kalah's seed count with the given index to zero.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to reset
:)
declare %updating function page:kalah-resetSeedCount($document, $kalahIndex) {
    page:kalah-setSeedCount($document, $kalahIndex, 0)
};



(:~
: This function sets kalah's seed count with the given index to the given seed count.
:
: @param $document XML document
: @param $kalahIndex index of kalah which seed count to set
: @param $seedCount seed count to set
:)
declare %updating function page:kalah-setSeedCount($document, $kalahIndex, $seedCount) {
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
declare %updating function page:updateHouseAfterMovingSeeds($document, $houseIndexStartMove, $seedsToMove, $houseToUpdate) {
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
declare %updating function page:updateKalahAfterMovingSeeds($document, $houseIndexStartMove, $seedsToMove, $kalahToUpdate) {
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
declare %updating function page:moveSeeds($document, $houseIndex, $seedsToMove) {
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
declare %updating function page:makeMove($document, $houseIndex) {
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
declare %updating function page:resetPlayersWinCount($player) {
    replace value of node $player/WinCount with 0

};



(:~
: This function resets the win counts, kalah's and house's seed counts.
:
: @param $document XML document
:)
declare  
%updating
%rest:path("/test")
  %rest:PUT
function page:resetGame() {
let $document := fn:doc("static/Game States/Game State 1.xml")
    for $player in $document/MancalaGame/Player
    
    return (
        page:resetPlayersWinCount($player) , 
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
declare %updating function page:resetSeedCountsOfPlayer($document, $playerIndex) {
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
declare %updating function page:switchPlayerOnTurn($document) {
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
