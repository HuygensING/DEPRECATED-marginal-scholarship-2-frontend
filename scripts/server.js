#!/usr/bin/env node

var browserSync = require("browser-sync").create();
var modRewrite = require("connect-modrewrite");
var debounce = require("lodash.debounce");
// var proxy = require("proxy-middleware");
// var url = require('url');

var baseDir = "./build/development";
var watchFiles = [
	baseDir + "/js/*.js",
	baseDir + "/css/*.css",
	baseDir + "/index.html"
];

function onFilesChanged(event, file) {
	if (event === "change") {
		browserSync.reload(file);
	}
}

browserSync.watch(watchFiles, debounce(onFilesChanged, 300));

// var proxyOptions = url.parse("http://demo7.huygens.knaw.nl/test-afp-backend");
// proxyOptions.route = "/api";

browserSync.init({
	server: {
		baseDir: baseDir,
		middleware: [
			// proxy(proxyOptions),
			modRewrite([
				"^/css/(.*)$ /css/$1 [L]",
				"^/js/(.*)$ /js/$1 [L]",
				"^/images/(.*)$ /images/$1 [L]",
				"^/fonts/(.*)$ /fonts/$1 [L]",
				"^[^\\.]*$ /index.html [L]"
			])
		]
	}
});
