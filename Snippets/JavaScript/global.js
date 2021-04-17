function GetURLParamLastPart() {
    var pathArray = window.location.pathname.split('/');
    return pathArray.slice(-1)[0];
}
