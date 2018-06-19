(function() {
  if (!window.addEventListener) return;
  var threshold = 200;
  var elementID = "table-of-contents";
  var timeoutPeriod = 100;
  var pending = false, prevVal = null;
  var done = false;

  function updateSoon() {
    if (!pending) {
      pending = true;
      setTimeout(update, timeoutPeriod);
    }
  }

  function update() {
    pending = false;
    var element = document.getElementById(elementID);
    if (element) {
      var marks = element.getElementsByTagName("a"), found;
      for (var i = 0; i < marks.length; ++i) {
	var mark = marks[i], m;
	if (mark.getAttribute("data-default")) {
	  if (found == null) found = i;
	} else if (m = mark.href.match(/#(.*)/)) {
	  var ref = document.getElementById(m[1]);
	  if (ref && ref.getBoundingClientRect().top < threshold)
	    found = i;
	}
      }
      if (found != null && found != prevVal) {
	prevVal = found;
	var lis = document.getElementById(elementID).getElementsByTagName("li");
	for (var i = 0; i < lis.length; ++i) lis[i].className = "";
	for (var i = 0; i < marks.length; ++i) {
	  if (found == i) {
	    marks[i].className = "active";
	    for (var n = marks[i]; n; n = n.parentNode)
	      if (n.nodeName == "LI") n.className = "active";
	  } else {
	    marks[i].className = "";
	  }
	}
      }
      // bug24534: Commented out since running the update function every 100ms
      // burns too much CPU time.  This shouldn't be necessary anyway.  Leave it
      // to the event listeners to trigger the update function.
      //setTimeout(update, timeoutPeriod);
    }
  }

  window.addEventListener("scroll", updateSoon);
  window.addEventListener("load", updateSoon);
  window.addEventListener("hashchange", function() {
    setTimeout(function() {
      var hash = document.location.hash, found = null, m;
      var marks = document.getElementById(elementID).getElementsByTagName("a");
      for (var i = 0; i < marks.length; i++)
        if ((m = marks[i].href.match(/(#.*)/)) && m[1] == hash) { found = i; break; }
      if (found != null) for (var i = 0; i < marks.length; i++)
        marks[i].className = i == found ? "active" : "";
    }, 300);
  });


})();

