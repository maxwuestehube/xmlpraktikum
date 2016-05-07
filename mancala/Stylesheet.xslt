<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output
        method="xml"
        indent="yes"
        standalone="no"
        doctype-public="-//W3C//DTD SVG 1.1//EN"
        doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
        media-type="image/svg" />
    
    <xsl:template match="Spieler">
        <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200" >
            <rect x="10" y="10" width="{AnzGewinne}" 
                height="5" fill="red" stroke="black"/>  
        </svg>
    </xsl:template>
    
</xsl:stylesheet>