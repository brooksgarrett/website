---
title: Nearly 150 Free Books
tags: [training]
date: "12 Aug 2013"
draft: false
slug: "free-books-from-msft"
---

Microsoft apparently has a phat stack of [free books](http://blogs.msdn.com/b/mssmallbiz/archive/2013/06/28/almost-150-free-microsoft-ebooks-covering-windows-7-windows-8-office-2010-office-2013-office-365-office-web-apps-windows-server-2012-windows-phone-7-windows-phone-8-sql-server-2008-sql-server-2012-sharepoint-server-2010-s.aspx)

Perhaps if you ran this in the Chrome Console good things will happen?

```js
function printLink(link) {
  if (link.textContent === 'MOBI'){
    console.log(link.href);
  }
}

var allLinks = document.links;
for (var i=0; i<allLinks.length; i++) {
  printLink(allLinks[i]);
}
```
