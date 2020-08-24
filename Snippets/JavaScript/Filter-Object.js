function FilterArray(array, term) {
    return array.filter(item => item.Text.toLowerCase().indexOf(term.toLowerCase()) > -1);
}

var sidekicks = [
    { name: "Robin",     hero: "Batman"   },
    { name: "Supergirl", hero: "Superman" },
    { name: "Oracle",    hero: "Batman"   },
    { name: "Krypto",    hero: "Superman" }
];

--------------------------------------
--------------------------------------
**FILTER** return LIST of results 
var batKicks = sidekicks.filter(function (el) {
    return (el.hero === "Batman");
});
--------------------------------------

--------------------------------------
**FIND** return FIRST result <runs very fast)
var result = ListOfSomeObjects.find(x => x.id === 250);
--------------------------------------
--------------------------------------
