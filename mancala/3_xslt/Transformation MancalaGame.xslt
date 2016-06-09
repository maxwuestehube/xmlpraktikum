<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns="http://www.w3.org/2000/svg" >
    
    <xsl:output
        method="xml"
        indent="yes"
        standalone="no"
        doctype-public="-//W3C//DTD SVG 1.1//EN"
        doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
        media-type="image/svg" />
    
    <!-- template that is called to draw seeds and count for each house and kalah -->
    <xsl:template name="drawSeedsAndCount">
        <xsl:param name="count" />
        <xsl:param name="x" />
        <xsl:param name="y" />
        
        <text x="{$x}" y="{$y}" fill="black"><xsl:value-of select="$count"/></text>
        
        <xsl:call-template name="drawSeeds">
            <xsl:with-param name="count"><xsl:value-of select="$count"/></xsl:with-param>
            <xsl:with-param name="x"><xsl:value-of select="$x"/></xsl:with-param>
            <xsl:with-param name="y"><xsl:value-of select="$y"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- auxiliary template for template drawSeedsAndCount -->
    <xsl:template name="drawSeeds">
        <xsl:param name="count" />
        <xsl:param name="x" />
        <xsl:param name="y" />
        
        <!-- check termination condition of recursion -->
        <xsl:if test="$count &gt; 0">
            
            <!-- calculate position of the one current seed -->
            <!-- $x is the position of the pile of seeds, $count is the index of the current seed -->
            <xsl:variable name="xPos" select="$x + 3 + 10 * ($count mod 4)" />
            <xsl:variable name="yPos" select="$y + 5 + 10 * ($count div 4)" />
            
            <!-- draw seed -->
            <use xlink:href="#seed" x="{$xPos}" y="{$yPos}"></use>

            <!-- recursive call of template to loop through the seeds -->
            <xsl:call-template name="drawSeeds">
                <xsl:with-param name="count" select="$count - 1" />
                <xsl:with-param name="x"><xsl:value-of select="$x"/></xsl:with-param>
                <xsl:with-param name="y"><xsl:value-of select="$y"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="MancalaGame">
        
        <svg xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns="http://www.w3.org/2000/svg" width="80%" height="100%">
            
            <desc>a Kalaha game</desc>
            
            <!-- definitioan of objects -->
            <defs>
                <g id="house">
                    <desc>a so-called Kalaha "house"</desc>
                    
                    <rect width="45" height="85" fill="white" stroke="black" stroke-width="2" ></rect>
                </g>
                
                <g id="kalah">
                    <desc>a so-called Kalaha "Kalah"</desc>
                    
                    <circle r="40" stroke="black" stroke-width="2,5" fill="white" />
                </g>
                
                <g id="seed">
                    <desc>a so-called Kalaha "seed"</desc>
                    
                    <circle r="4" stroke="#00A4DE" stroke-width="2,5" fill="#00A4DE" />
                </g>
                
                <g id="board">
                    <desc>the actual Kalaha board, presented in traditional layout</desc>
                    
                    <!-- board frame -->
                    <path d="M0 40 Q 0 0 40 0
                        L 535 0
                        M535 0 Q 575 0 575 40
                        L 575 195
                        M575 195 Q 575 235 535 235
                        L 40 235
                        M40 235 Q 0 235 0 195
                        L 0 40" stroke="black" stroke-width="2,5" fill="#E8F9FF"/>
                    
                    <!-- player one's kalah -->
                    <use xlink:href="#kalah" x="60" y="120"></use>
                    
                    <!-- player one's houses -->
                    <use xlink:href="#house" x="115" y="20"></use>
                    <use xlink:href="#house" x="175" y="20"></use>
                    <use xlink:href="#house" x="235" y="20"></use>
                    <use xlink:href="#house" x="295" y="20"></use>
                    <use xlink:href="#house" x="355" y="20"></use>
                    <use xlink:href="#house" x="415" y="20"></use>
                    
                    <!-- player two's kalah -->
                    <use xlink:href="#kalah" x="515" y="120"></use>
                    
                    <!-- player two's houses -->
                    <use xlink:href="#house" x="115" y="130"></use>
                    <use xlink:href="#house" x="175" y="130"></use>
                    <use xlink:href="#house" x="235" y="130"></use>
                    <use xlink:href="#house" x="295" y="130"></use>
                    <use xlink:href="#house" x="355" y="130"></use>
                    <use xlink:href="#house" x="415" y="130"></use>
                    
                    <!-- insert data from XML -->
                    
                    <!-- names of players, seeds in their kalahs, count of wins, count of seeds collected  -->
                    <xsl:for-each select="Player">
                        <xsl:variable name="playerIndex" select="position()" />
                        
                        <!-- calculate location of seeds and captions -->
                        <xsl:variable name="playerX" select="25 + ($playerIndex - 1) * 465" />
                        
                        <!-- player name -->
                        <text x="{$playerX}" y="175" fill="black"><xsl:value-of select="Name"/></text>
                        
                        <!-- seeds -->
                        <xsl:call-template name="drawSeedsAndCount">
                            <xsl:with-param name="count"><xsl:value-of select="PlayersHalf/Kalah/SeedCount"/></xsl:with-param>
                            <xsl:with-param name="x"><xsl:value-of select="$playerX"/></xsl:with-param>
                            <xsl:with-param name="y">105</xsl:with-param>
                        </xsl:call-template>
                        
                        <!-- counts of win and seeds collected -->
                        <text x="{$playerX -25}" y="250" fill="black">Anzahl Gewinne: <xsl:value-of select="WinCount"/></text>
                        <text x="{$playerX -25}" y="275" fill="black">Anzahl Samen: <xsl:value-of select="SeedCount"/></text>
                    </xsl:for-each>
                    
                    <!-- seeds in houses -->
                    <xsl:for-each select="Player">
                        <xsl:variable name="playerIndex" select="position()" />
                        
                        <xsl:for-each select="PlayersHalf/House">
                            <xsl:variable name="houseIndex" select="position()" />
                            
                            <!-- calculate seeds position -->
                            <xsl:variable name="seedsX" select="120 + ($houseIndex - 1) * 60" />
                            <xsl:variable name="seedsY" select="35 + ($playerIndex - 1) * 110" />
                            
                            <!-- draw seeds -->
                            <xsl:call-template name="drawSeedsAndCount">
                                <xsl:with-param name="count"><xsl:value-of select="SeedCount"/></xsl:with-param>
                                <xsl:with-param name="x"><xsl:value-of select="$seedsX"/></xsl:with-param>
                                <xsl:with-param name="y"><xsl:value-of select="$seedsY"/></xsl:with-param>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:for-each>
                    
                    <!-- indication who is on turn -->
                    <text x="200" y="305" fill="black">Spieler am Zug: <xsl:value-of select="PlayerOnTurn"/></text>
                </g>
                
                <g id="button_new_game">
                    <desc>a button for starting a new game</desc>
                    
                    <rect width="125" height="30" fill="white" stroke="black" stroke-width="2" ></rect>
                    <text x="10" y="20" fill="black">Start new Game</text>
                </g>
                
                <g id="button_undo_move">
                    <desc>a button for undoing a move</desc>
                    
                    <rect width="97" height="30" fill="white" stroke="black" stroke-width="2" ></rect>
                    <text x="10" y="20" fill="black">Undo Move</text>
                </g>
                
                <g id="logo">
                    <desc>a logo</desc>
                    
                    <text x="10" y="25" fill="black">Kalaha</text>
                </g>
            </defs>
            
            <!-- display Kalaha game -->
            <use xlink:href="#logo" x="0" y="0"></use>
            <use xlink:href="#button_new_game" x="0" y="40"></use>
            <use xlink:href="#button_undo_move" x="145" y="40"></use>
            <use xlink:href="#board" x="0" y="90"></use>
        </svg>
    </xsl:template>
    
</xsl:stylesheet>