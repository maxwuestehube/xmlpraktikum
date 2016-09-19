(:~
: This file implementats of the game Mancala as a web application.
: It offers the possibility to play simultaneous games of Mancala which state is persisted at server-side at the same time.
: It exclusively uses XML technologies.
: On server-side BaseX, RestXQ, XQuery, XSLT and XPath are used.
: On client-side HTML, HTML forms and SVG are used.
:
: @author Alexandra Brandner, Meryem Oezkaya, Max Wuestehube
:)



(: namespace declaration :)
module namespace mancala = 'mancala.xmlpraktikum';



(:~
: Creates a temporary file of a new Mancala game with unique id. It returns the id.
:
: @return unique identifier of Mancala game state, the id is a random number that might either be positive or negative
:)
declare function mancala:generateNewGameState() {
    let $fileName := file:create-temp-file('mancala-game_', '.xml'),
        $tmp := file:copy('/srv/BaseXWeb/gameState.xml', $fileName),
        $gameId := replace(replace($fileName, '/tmp/mancala-game_', ''), '.xml', '')
    return $gameId
};

(:~
: Returns XML data of a game state by the given id. The returned doc object may be used for XPath requests.
:
: @param $id id of the game state to retrieve
:)
declare function mancala:getGameStateDocument($id) {
    doc(concat('/tmp/', 'mancala-game_', $id, '.xml'))
};

(:~
: Returns a SVG corresponding to the game state with the given id.
:
: @param $id id of the game state to visualize
: @return SVG representing the game state
:)
declare function mancala:getBoard($id) {
    (: use XSLT :)
    xslt:transform(mancala:getGameStateDocument($id), 'gameStateToBoardTransformation.xslt')
};

(:~
: Serves the start page of the game. Collects user names as input.
:
: @return a HTML page displaying the start screen of the game
:)
(:Start Page of Game:)
declare
    (: path :)
    %rest:path("mancala/start")
    %rest:GET
    function mancala:start_collectInput()
{
    (: initialize game :)
    let $gameId := mancala:generateNewGameState()
    return
        concat('<html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Ein neues Kalaha-Spiel starten</title>
            </head>
            <body>
                <h1>Ein neues Kalaha-Spiel starten.</h1>

                <p>Bitte geben Sie die Namen der Spieler ein.</p>

                <form action="start-process-information" method="post" target="frame-to-handle-post-requests">
                    <input type="hidden" name="id" value="', $gameId,'" />
                    <p>Name Spieler 1:<br /><input type="text" name="p1" /></p>
                    <p>Name Spieler 2:<br /><input type="text" name="p2" /></p>

                    <!-- save player names: POST -->
                    <input type="submit" value="Absenden (POST)" />
                </form>

                <p>Haben Sie die Namen eingegeben und bestätigt, können Sie nun das Spiel starten.</p>

                <form action="play" method="get">
                    <input type="hidden" name="id" value="', $gameId,'" />

                    <!-- proceed to game: GET -->
                    <input type="submit" value="Weiter zum Spielfeld (GET)" />
                </form>

                <!-- create a hidden iframe to handle post requests, since it is not possible to update and return data at the same time using XQuery -->
                <iframe style="visibility: hidden;" name="frame-to-handle-post-requests" id="frame-to-handle-post-requests"></iframe>
            </body>
        </html>')
};

(:~
: Sets the node of player on turn of the given game state document to player one.
:
: @param $document game state document
: @param $player-1-name name of player one
:)
declare updating function mancala:setFirstPlayerToBeOnTurn($document, $player-1-name) {
    let $tmp := ''
    return replace value of node $document/MancalaGame/PlayerOnTurn with $player-1-name
};

(:~
: Updates the nodes of the player names in the given game state document according to the names provided.
:
: @param $document game state document
: @param $player-1-name name of player one
: @param $player-2-name name of player two
:)
declare updating function mancala:setPlayersNames($document, $player-1-name, $player-2-name) {
    let $tmp := ''
    return (
        replace value of node $document/MancalaGame/Player[1]/Name with $player-1-name,
        replace value of node $document/MancalaGame/Player[2]/Name with $player-2-name
    )
};

(:~
: Processes the player names provided by the user in the start screen.
:
: @param $gameId id of the game to input process on
: @param $player-1-name name of player one
: @param $player-2-name name of player two
:)
declare updating
    (: path :)
    %rest:path("mancala/start-process-information")
    %rest:POST
    %rest:form-param("id", "{$gameId}", "")
    %rest:form-param("p1", "{$player-1-name}", "Spieler 1")
    %rest:form-param("p2", "{$player-2-name}", "Spieler 2")
    function mancala:start_processInput($gameId, $player-1-name, $player-2-name)
{
    let $document := mancala:getGameStateDocument($gameId)
    return (
        (: set up game for the start :)
        mancala:setPlayersNames($document, $player-1-name, $player-2-name),
        mancala:setFirstPlayerToBeOnTurn($document, $player-1-name)
    )
};

(:~
: Serves the page displaying the actual game.
:
: @param $gameId id of the game to display
: @return page displaying the actual game
:)
declare
    %rest:path("mancala/play")
    %rest:query-param("id", "{$gameId}", "")
    %rest:GET
    function mancala:play($gameId)
    as element(Q{http://www.w3.org/1999/xhtml}html)
{
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <title>Kalaha</title>
        </head>
        <body>
            <h1>Kalaha</h1>

            <p>"Kalaha, im englischen Sprachraum Kalah, im deutschen Sprachraum auch Steinchenspiel genannt, ist ein modernes Strategiespiel der Mancala-Familie (von arab.: نقل‎ / naqala / ‚befördern, transportieren‘) für zwei Spieler. Mancala (auch: Mankala, Manqala) ist der wissenschaftliche Gattungsbegriff (generischer Terminus) für eine Gruppe von Brettspielen, bei denen der Inhalt von Mulden nach bestimmten Regeln umverteilt wird. In Deutschland benutzt man auch den Begriff Bohnenspiele."</p>
            <p>Quelle: <a href="https://de.wikipedia.org/wiki/Kalaha">https://de.wikipedia.org/wiki/Kalaha</a>, abgerufen am 08.09.16</p>

            <p>{ mancala:getBoard($gameId) }</p>

            <h2>Spielen</h2>

            <p>Ist der Spieler, der links steht am Zug, bezieht sich die Mulden-Auswahl auf die obere Muldenreihe, sonst auf die untere.</p>

            <form action="play-process-information" method="post" target="frame-to-handle-post-requests">
                <input type="hidden" name="id" value="{ $gameId }" />

                Mulde auswählen:

                <select name="house">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                </select>

                <input type="submit" value="Zug absenden (POST)" />
            </form>

            <p>Nachdem die Mulde ausgewählt wurde, kann das Spielfeld aktualisiert werden.</p>

            <form action="play" method="get">
                <input type="hidden" name="id" value="{ $gameId }" />

                <input type="submit" value="Spielfeld aktualisieren (GET)" />
            </form>

            <h2>Zurücksetzen</h2>

            <!-- reset game -->
            <form action="start" method="get">
                <input type="submit" value="Neues Spiel" />
            </form>

            <!-- hidden iframe to handle POST requests -->
            <iframe style="visibility: hidden;" name="frame-to-handle-post-requests" id="frame-to-handle-post-requests"></iframe>
        </body>
    </html>
};

(:~ 
: Concept: conversion between:
: - xml index: combination of: 1) player on turn, 2) index of house from right to left from 1 to 6
: - internal index: from 0 (first house of player 1) counter-clockwise over 5 (sixth house of player 1)
: over 6 (kalah of player 1) over 7 (first house of player 2) over 12 (sixth house of player 2) to 13 (kalah of player 2)
:
: Converts XML index to internal index.
:
: @param $playerIndex index of player
: @param $houseIndex index of house
: @return internal index
:)
declare function mancala:getInternalIndexFromXmlIndex($playerIndex, $houseIndex) {
    let $i := if ($playerIndex = 1) then (6 - $houseIndex) else (6 + $houseIndex)
    return $i
};

(:~
: Extracts player index from internal index.
:
: @param $i internal index
: @return player index
:)
declare function mancala:getPlayerIndexFromInternalIndex($i) {
    let $playerIndex := if ($i <= 6) then (1) else (2)
    return $playerIndex
};

(:~
: Extracts house index from internal index.
:
: @param $i internal index
: @return house index
:)
declare function mancala:getHouseIndexFromInternalIndex($i) {
    let $playerIndex := mancala:getPlayerIndexFromInternalIndex($i)
    return (if ($playerIndex = 1) then (6 - $i) else ($i - 6))
};

(:~
: Retrieves the index of the player who is on turn from the given game state document.
:
: @param $document game state document
: @return either 1 or 2
:)
declare function mancala:getPlayerOnTurnIndex($document) {
    let $playerOneName := $document/MancalaGame/Player[1]/Name,
        $playerOnTurnName := $document/MancalaGame/PlayerOnTurn
    return (if ($playerOneName = $playerOnTurnName) then (1) else (2))
};

(:~
: Returns a kalah's or house's seed count, depending on (internal) index.
:
: @param $document game state document
: @param $i house/kalah index
: @return seed count of house/kalah with given index
:)
declare function mancala:getHouseOrKalahSeedCount($document, $i) {
    let $playerIndex := mancala:getPlayerIndexFromInternalIndex($i),
        $houseIndex := mancala:getHouseIndexFromInternalIndex($i),
        $kalahSeedCount := $document/MancalaGame/Player[$playerIndex]/PlayersHalf/Kalah/SeedCount,
        $houseSeedCount := $document/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseIndex]/SeedCount

    return if (($i = 6) or ($i = 13)) then (
        if ($kalahSeedCount = '') then (0) else ($kalahSeedCount)
    ) else (
        if ($houseSeedCount = '') then (0) else ($houseSeedCount)
    )
};

(:~
: Sets a house's or kalah's seed count according to the given (internal) index.
:
: @param $document game state document
: @param $i (internal) index of house or kalah which's seed count to set
: @param $seedCount seed count to set
:)
declare updating function mancala:setHouseOrKalahSeedCount($document, $i, $seedCount) {
    let $playerIndex := mancala:getPlayerIndexFromInternalIndex($i),
        $houseIndex := mancala:getHouseIndexFromInternalIndex($i)

    return if (($i = 6) or ($i = 13)) then (
        (: kalah :)
        replace value of node $document/MancalaGame/Player[$playerIndex]/PlayersHalf/Kalah/SeedCount with $seedCount
    ) else (
        (: house :)
        replace value of node $document/MancalaGame/Player[$playerIndex]/PlayersHalf/House[$houseIndex]/SeedCount with $seedCount
    )
};

(:~
: Returns the seed count a house/kalah will have after a given move has been played.
: It implements the rules of Mancala.
:
: @param $document game state document
: @param $i starting (internal) index of move to take into account
: @param $seedCount number of seeds in the house the move starts at
: @param $j (internal) index of house or kalah which's seed count after the move should be retrieved
: @return seed count after the move has been played of house/kalah with internal index $j
:)
declare function mancala:getNewSeedCountInHouseOrKalahAfterMove($document, $i, $seedCount, $j) {
    let $finalPosition := mancala:getFinalMovePosition($i, $seedCount),  (: index of house/kalah the last seed will be in after the move :)
        $indexOpposingHouse := mancala:getOpposingHouse($finalPosition), (: index of house of other Player on opposite position :)
        $seedCountJ := mancala:getHouseOrKalahSeedCount($document, $j),  (: seed count of a house/kalah that will be modified by the move :)

        (: calculate the number of additional seeds that will be added to house/kalah $j :)
        $numOfAdditionalNewSeeds :=
            if ($i < $j) then (
            (: internal index will not be overlapped :)
                if ($i <= 6) then (
                    (: player 1 on turn :)
                    if ($j <= 6) then (
                        if (($i + $seedCount) < $j) then (0) else (1)
                    ) else (
                    (: kalah of opponent is skipped when making a move :)
                        if ($j = 13) then (0) else (
                            if (($i + $seedCount) < $j) then (0) else (1)
                        )
                    )
                ) else (
                    (: player 2 on turn, i > 6 => j > 6 :)
                    if (($i + $seedCount) < $j) then (0) else (1)
                )
            ) else (
                (: lap :)
                if (($i > 6) and ($j <= 6)) then (
                (: player 2 on turn :)
                    if ((($i + $seedCount) > 13) and (($i + $seedCount) mod 14) >= $j) then (1) else (0)
                ) else (
                (: player 1 on turn :)
                    if (($i + 14 - $j) > $seedCount) then (
                        floor($seedCount div 14)
                    ) else (0)
                )
            )

    (: returns new seed count of $j, dependung on finalPosition: if it is a kalaha, the same player is on turn for the next move, otherwise the player on turn will be switched :)
    return if (((mancala:getHouseOrKalahSeedCount($document, $finalPosition) = 0) and $finalPosition != 6 and $finalPosition != 13) and (($i <= 6 and $j = 6) or ($i > 6 and $j = 13)) and (mancala:getHouseOrKalahSeedCount($document, $indexOpposingHouse) > 0)) then (
            (: kalahs :)
            if (($i <= 6 and $finalPosition <= 6) or ($i > 6 and $finalPosition > 6)) then (
                $seedCountJ + mancala:getHouseOrKalahSeedCount($document, $indexOpposingHouse) + 1
            ) else (
                $seedCountJ + 1
            )
        ) else (
            (: houses, also checks for a potential capture :)
            if ($j = $indexOpposingHouse and $finalPosition != 6 and $finalPosition != 13 and mancala:getHouseOrKalahSeedCount($document, $finalPosition) = 0 and (($i <= 6 and $finalPosition <= 6) or ($i > 6 and $finalPosition > 6)) and (mancala:getHouseOrKalahSeedCount($document, $indexOpposingHouse) > 0)) then (
                0
            ) else (
                if ($j = $finalPosition and $finalPosition != 6 and $finalPosition != 13 and mancala:getHouseOrKalahSeedCount($document, $finalPosition) = 0 and (($i <= 6 and $finalPosition <= 6) or ($i > 6 and $finalPosition > 6)) and (mancala:getHouseOrKalahSeedCount($document, $indexOpposingHouse) > 0)) then (
                    0
                ) else (
                    if ($i = $j) then ( $numOfAdditionalNewSeeds ) else ($seedCountJ + $numOfAdditionalNewSeeds )
                )
            )
        )
};

(:~
: Updates a given house or kalah after a given move.
:
: @param $document game state document
: @param $i (internal) start index of move
: @param $seedCount seed count in start house of move
: @param $j (internal) index of house/kalah to update
:)
declare updating function mancala:updateHouseOrKalahSeedCountAfterMove($document, $i, $seedCount, $j) {
    let $newSeedCount := mancala:getNewSeedCountInHouseOrKalahAfterMove($document, $i, $seedCount, $j)
    return mancala:setHouseOrKalahSeedCount($document, $j, $newSeedCount)
};

(:~
: Helper function for moveSeeds. Calls updateHouseOrKalahSeedCountAfterMove recursively.
:
: @param $document game state document
: @param $i (internal) start index of move
: @param $seedCount seed count in start house of move
: @index current index to call updateHouseOrKalahSeedCountAfterMove on
:)
declare updating function mancala:moveSeedsHelper($document, $i, $seedCount, $index) {
    let $tmp := ''
    return mancala:updateHouseOrKalahSeedCountAfterMove($document, $i, $seedCount, $index),
        if ($index > 0) then (mancala:moveSeedsHelper($document, $i, $seedCount, $index - 1)) else ()
};

(:~
: Moves seeds according to house chosen by player for the turn.
:
: @param $document game state document
: @param $i (internal) index of house the player has chosen for the turn
:)
declare updating function mancala:moveSeeds($document, $i) {
    (: update houses and kalah seed counts :)
    let $seedCount := mancala:getHouseOrKalahSeedCount($document, $i)
    return mancala:moveSeedsHelper($document, $i, $seedCount, 13)
};

(:~
: Switches the player on turn.
:
: @param $document game state document
:)
declare updating function mancala:switchPlayerOnTurn($document) {
    let $playerOneName := $document/MancalaGame/Player[1]/Name,
        $playerTwoName := $document/MancalaGame/Player[2]/Name,
        $playerOnTurnName := $document/MancalaGame/PlayerOnTurn
    return if ($playerOneName = $playerOnTurnName) then (
            replace value of node $document/MancalaGame/PlayerOnTurn with $playerTwoName
        ) else (
            replace value of node $document/MancalaGame/PlayerOnTurn with $playerOneName
        )
};

(:~
: Returns the (internal) index of the final position a given move will reach.
:
: @param $i (internal) start index of given move
: @param $seedCount seed count in starting house of given move
:)
declare function mancala:getFinalMovePosition($i, $seedCount) {
    (: skip opponent's kalah :)
    let $offset := if ($i <= 6) then (
            if (($i + $seedCount) >= 13) then (1) else (0)
        ) else (
            if (($i + $seedCount) >= 20) then (1) else (0)
        ),
        $finalPosition := ($i + $offset + $seedCount) mod 14
    return $finalPosition
};

(:~
: Returns either 'true' or 'false' depending on wether the last seed of a move lands in a kalah.
:
: @param $document game state document
: @param $i start index of given move
: @return either 'true' or 'false'
:)
declare function mancala:isLastSeedInKalah($document, $i) {
    let $seedCount := mancala:getHouseOrKalahSeedCount($document, $i),
        $finalPosition := mancala:getFinalMovePosition($i, $seedCount),
        $lastSeedIsInKalah := if (($finalPosition = 6) or (($finalPosition = 13))) then ('true') else ('false')
    return $lastSeedIsInKalah
};

(:~
: Helper function of getSeedCountInHousesHelper. Sums up seed counts recursively.
:
: @param $document game state document
: @param $i (internal) start index of move
: @param $seedCount seed count at start house of move
: @param $index (internal) index of house/kalah to start counting on
: @param $endIndex (internal) index of house/kalah to stop counting on
:)
declare function mancala:getSeedCountInHousesHelper($document, $playerIndex, $i, $seedCount, $index, $endIndex) {
    let $currentSeedCount := mancala:getNewSeedCountInHouseOrKalahAfterMove($document, $i, $seedCount, $index)
    return if ($index > $endIndex) then (
        $currentSeedCount + mancala:getSeedCountInHousesHelper($document, $playerIndex, $i, $seedCount, $index - 1, $endIndex)
    ) else ($currentSeedCount)
};

(:~
: Returns the total seed count in houses of one player after a given move.
:
: @param $document game state document
: @param $playerIndex index of player (either 1 or 2) whose seed count should be returned
: @param $i (internal) start index of move
: @param $seedCount seed count at start house of move
: @return total seed count in houses of one given player after a given move
:)
declare function mancala:getSeedCountInHouses($document, $playerIndex, $i, $seedCount) {
    let $seedCountInHouses := if ($playerIndex = 1) then (
            mancala:getSeedCountInHousesHelper($document, $playerIndex, $i, $seedCount, 5, 0)
        ) else (
            mancala:getSeedCountInHousesHelper($document, $playerIndex, $i, $seedCount, 12, 7)
        )
    return $seedCountInHouses
};

(:~
: Returns the total seed count in houses and kalah of one player after a given move.
:
: @param $document game state document
: @param $playerIndex index of player (either 1 or 2) whose seed count should be returned
: @param $i (internal) start index of move
: @param $seedCount seed count at start house of move
: @return total seed count of one given player after a given move
:)
declare function mancala:getSeedCountTotalExpected($document, $playerIndex, $i, $seedCount) {
    let $seedCountTotalExpected := mancala:getSeedCountInHouses($document, $playerIndex, $i, $seedCount) + mancala:getNewSeedCountInHouseOrKalahAfterMove($document, $i, $seedCount, $playerIndex * 7 - 1)
    return $seedCountTotalExpected
};

(:~
: Switches the player on turn according to checks of:
: - bonus move
: - game over.
:
: @param $document game state document
: @param $lastSeedIsInKalah either 'true' or 'false' depending on wether the last seed of a given move is placed in a kalah
: @param $i (internal) start index of move
: @param $seedCount seed count at start house of move
:)
declare updating function mancala:switchPlayerOnTurnCheckBonusMoveCheckGameOver($document, $lastSeedIsInKalah, $i, $seedCount) {
    let $seedCountInHousesPlayerOne := mancala:getSeedCountInHouses($document, 1, $i, $seedCount),
        $seedCountInHousesPlayerTwo := mancala:getSeedCountInHouses($document, 2, $i, $seedCount)
    return if (($seedCountInHousesPlayerOne = 0) or ($seedCountInHousesPlayerTwo = 0)) then (
            (: game over :)
            replace value of node $document/MancalaGame/PlayerOnTurn with concat('Game over (', mancala:getSeedCountTotalExpected($document, 1, $i, $seedCount), ' zu ', mancala:getSeedCountTotalExpected($document, 2, $i, $seedCount), ')')
        ) else (
            (: check for bonus move :)
            if ($lastSeedIsInKalah = 'true') then () else (mancala:switchPlayerOnTurn($document))
        )
};

(:~
: Returns the (internal) index of the opposing house of a given (internal) index.
:
: @param $i (internal) index of house for which to find the opposing one
: @return (internal) index of the opposing house
:)
declare function mancala:getOpposingHouse($i) {
    let $indexOpposingHouse := if ($i = 6 or $i = 13) then (-1) else (
            12 - $i
        )
    return $indexOpposingHouse
};

(:~
: Processes the player's selection of a house for the turn.
: Updates the game state document after a move.
:
: @param gameId id of the game
: @param $houseIndex index of the house (1-6) the player chose for the turn
:)
declare updating
    %rest:path("mancala/play-process-information")
    %rest:POST
    %rest:form-param("id","{$gameId}", "")
    %rest:form-param("house","{$houseIndex}", 0)
    function mancala:play_processInput($gameId, $houseIndex)
{
    let $document := mancala:getGameStateDocument($gameId),
        $playerOnTurnIndex := mancala:getPlayerOnTurnIndex($document),
        $i := mancala:getInternalIndexFromXmlIndex($playerOnTurnIndex, $houseIndex),
        $lastSeedIsInKalah := mancala:isLastSeedInKalah($document, $i),
        $seedCount := mancala:getHouseOrKalahSeedCount($document, $i)
    return (
        (: perform the plays :)
        mancala:moveSeeds($document, $i),
        mancala:switchPlayerOnTurnCheckBonusMoveCheckGameOver($document, $lastSeedIsInKalah, $i, $seedCount)
    )
};
