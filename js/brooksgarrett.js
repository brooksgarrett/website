function getElementByXpath (path) {
  return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

function setActiveNav(){
    var navLinks = getElementByXpath("/html/body/nav/div/div[2]/ul").getElementsByTagName("li");
    var currentURL = document.URL;
    
    for (var i = 0; i < navLinks.length; ++i) {
        var item = navLinks[i];  // Calling myNodeList.item(i) isn't necessary in JavaScript
        var link = navLinks[i].getElementsByTagName("a");
        link = link[0].href;
        if (link.substring(link.length-1, link.length) == "/") {
            link = link + "index.html";
        }
        if (currentURL.substring(currentURL.length-1, currentURL.length) == "/") {
            currentURL = currentURL + "index.html";
            
        }
        if (link == currentURL) {
            item.className = "active";
            break;
        } else {
            item.className = "";
        }
    }
}
