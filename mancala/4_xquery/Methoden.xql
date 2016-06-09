declare namespace local="local";

declare function local:getCurrentPlayer($this)
{
    for $x in doc("books.xml")/bookstore/book
    where $x/price>30
    return $x/title
};

local:getCurrentPlayer(fn:doc("books.xml")/bookstore/book)