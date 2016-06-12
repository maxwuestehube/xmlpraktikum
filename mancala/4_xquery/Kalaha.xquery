declare namespace kalaha = "kalaha";

declare updating function kalaha: increaseSeedCount($this,$SeedCount){

    replace value of node $this with $this + $SeedCount

};

declare updating function kalaha:setSeedCount($this,$kalahaCount){

    replace value of node $this with $kalahaCount
};


