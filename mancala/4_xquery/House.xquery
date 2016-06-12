declare namespace house = "house";

declare updating function house:increaseSeedCount ($this, $seedCount) {
    
    replace value of node $this with $this + $seedCount
};

    
house:increaseSeedCount(fn:doc("../3_xslt/Game States/Game State 1.xml"))

declare updating function house:setSeedCount($this, $seedCount){
    
    replace value of node $this with $seedCount
};


declare function house:getSeedCount($this)
as xs:integer
{
    let $this := $this
    return $this
};