/*
 *
 * @licstart  The following is the entire license notice for the
 *  JavaScript code in this page.
 *
 * Copyright (C) 2018 Jaume Fuster i Claris
 *
 *
 * The JavaScript code in this page is free software: you can
 * redistribute it and/or modify it under the terms of the GNU
 * General Public License (GNU GPL) as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option)
 * any later version.  The code is distributed WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU GPL for more details.
 *
 * As additional permission under GNU GPL version 3 section 7, you
 * may distribute non-source (e.g., minimized or compacted) forms of
 * that code without the copy of the GNU GPL normally required by
 * section 4, provided you include this license notice and a URL
 * through which recipients can access the Corresponding Source.
 *
 * @licend  The above is the entire license notice
 * for the JavaScript code in this page.
 *
 */

// "Thus, programs must be written for people to read, and only incidentally for machines to execute."
// TODO: Commenting.


// ---------- CONFIGURATION ----------

// div.innerHTML : {a.innerHTML : a.href}
var sites = {
	"Courses": {
		"DBS": "https://courses.fit.cvut.cz/BI-DBS/index.html",
		"GIT": "https://courses.fit.cvut.cz/BI-GIT/index.html",
		"LIN": "https://courses.fit.cvut.cz/BI-LIN/index.html",
		"LNG": "https://moodle-vyuka.cvut.cz/course/view.php?id=5101",
		"PA2": "https://courses.fit.cvut.cz/BI-PA2/index.html",
		"SAP": "https://courses.fit.cvut.cz/BI-SAP/index.html",
	},
	"School sites": {
		"DBS portál": "https://dbs.fit.cvut.cz/",
		"Grades": "https://grades.fit.cvut.cz/",
		"KOS": "https://www.kos.cvut.cz/kos/logout.do",
		"MARAST": "http://marast.fit.cvut.cz/",
		"Odevzdávač": "https://ddd.fit.cvut.cz/odevzdavac/st-1100/?page=main",
		"ProgTest": "https://progtest.fit.cvut.cz/",
	},
	"Local": {
		"Home Assistant": "http://192.168.0.151:8123/lovelace/default_view",
		"Pi-hole": "http://server.lan/admin/",
		"Plex": "http://server.lan:32400/web/index.html",
		"qBittorrent": "http://server.lan:8080/",
		"Radarr": "http://server.lan:7878/",
		"Sonarr": "http://server.lan:8989/",
	}
};

var search = { // Query variable name is q, hardcoded, looks like a standard already anyways
	"default": "https://google.com/search",
	"d": "https://duckduckgo.com/",
	"s": "https://startpage.com/do/search",
	"r": "https://reddit.com/search"
};

// ---------- BUILD PAGE ----------
var pivotmatch = 0;
var totallinks = 0;
var prevregexp = "";
function matchLinks(regex = prevregexp) {
	totallinks = 0;
	pivotmatch = regex == prevregexp ? pivotmatch : 0;
	prevregexp = regex;
	pivotbuffer = pivotmatch;
	p = document.getElementById("links");
	while (p.firstChild) {
		p.removeChild(p.firstChild);
	}
	if (regex.charAt(1) == ' ' && search.hasOwnProperty(regex.charAt(0))) {
		document.getElementById("action").action = search[regex.charAt(0)];
		document.getElementById("action").children[0].name = "q";
	} else {
		match = new RegExp(regex ? regex : ".", "i");
		gmatches = false; // kinda ugly, rethink
		for (i = 0; i < Object.keys(sites).length; i++) {
			matches = false;
			sn = Object.keys(sites)[i];
			section = document.createElement("div");
			section.id = sn;
			section.innerHTML = sn;
			section.className = "section";
			inner = document.createElement("div");
			for (l = 0; l < Object.keys(sites[sn]).length; l++) {
				ln = Object.keys(sites[sn])[l];
				if (match.test(ln)) {
					link = document.createElement("a");
					link.href = sites[sn][ln];
					link.innerHTML = ln;
					if (!pivotbuffer++ && regex != "") {
						link.className = "selected";
						document.getElementById("action").action = sites[sn][ln];
						document.getElementById("action").children[0].removeAttribute("name");
					}
					inner.appendChild(link);
					matches = true;
					gmatches = true;
					totallinks++;
				}
			}
			section.appendChild(inner);
			matches ? p.appendChild(section) : false;
		}
		if (!gmatches || regex == "") {
			document.getElementById("action").action = search["default"];
			document.getElementById("action").children[0].name = "q";
		}
	}
	document.getElementById("main").style.height = document.getElementById("main").children[0].offsetHeight + "px";
}

document.onkeydown = function (e) {
	switch (e.keyCode) {
		case 38:
			pivotmatch = pivotmatch >= 0 ? 0 : pivotmatch + 1;
			matchLinks();
			break;
		case 40:
			pivotmatch = pivotmatch <= -totallinks + 1 ? -totallinks + 1 : pivotmatch - 1;
			matchLinks();
			break;
		default:
			break;
	}
	document.getElementById("action").children[0].focus();
}

document.getElementById("action").children[0].onkeypress = function (e) {
	if (e.key == "ArrowDown" || e.key == "ArrowUp") {
		return false;
	}
}

function displayClock() {
	now = new Date();
	clock = (now.getHours() < 10 ? "0" + now.getHours() : now.getHours()) + ":"
		+ (now.getMinutes() < 10 ? "0" + now.getMinutes() : now.getMinutes()) + ":"
		+ (now.getSeconds() < 10 ? "0" + now.getSeconds() : now.getSeconds());
	document.getElementById("clock").innerHTML = clock;
}

function displayGreeting() {
	now = new Date();
	if (now.getHours() >= 18 || now.getHours() < 4) { greeting = "こんばんは" }
	else if (now.getHours() >= 10) { greeting = "こんにちは" }
	else { greeting = "おはよう" };
	document.getElementById("greeting").innerHTML = greeting;
}

window.onload = matchLinks();
document.getElementById("action").onsubmit = function () {
	svalue = this.children[0].value;
	if (svalue.charAt(1) == ' ' && search.hasOwnProperty(svalue.charAt(0))) {
		this.children[0].value = svalue.substring(2);
	}
	return true;
}
displayClock();
displayGreeting();
setInterval(displayClock, 1000);
setInterval(displayGreeting, 60000);
