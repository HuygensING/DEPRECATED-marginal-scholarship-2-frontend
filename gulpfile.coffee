gulp = require 'gulp'
gutil = require 'gulp-util'

extend = require 'extend'

browserSync = require 'browser-sync'
modRewrite = require 'connect-modrewrite'

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'

stylus = require 'gulp-stylus'
nib = require 'nib'
rename = require 'gulp-rename'
concat = require 'gulp-concat'

jade = require 'gulp-jade'

# connect = require 'gulp-connect'
# coffee = require 'gulp-coffee'
# minifyCss = require 'gulp-minify-css'
# uglify = require 'gulp-uglify'
# streamify = require 'gulp-streamify'
# clean = require 'gulp-clean'

# bodyParser = require 'body-parser'
# modRewrite = require 'connect-modrewrite'
# proxy = require('proxy-middleware')
# exec = require('child_process').exec
# url = require('url')
# async = require 'async'
# rimraf = require 'rimraf'

# connectRewrite = require './connect-rewrite'
# pkg = require './package.json'
# cfg = require './config.json'

cssFiles = [
	'./node_modules/hibb-faceted-search/dist/main.css'
	'./node_modules/hibb-pagination/dist/main.css'
	'./node_modules/hibb-modal/dist/main.css'
]

gulp.task 'copy-svg', ->
	gulp.src('./node_modules/hi-svg-icons/*.svg')
		.pipe(gulp.dest('./build/development/svg'))

gulp.task 'server', ['concatCss', 'stylus', 'copy-svg', 'watch', 'watchify'], ->
	browserSync
		server:
			baseDir: './build/development'
			middleware: [
				# proxy(proxyOptions),
				modRewrite([
					'^[^\\.]*$ /index.html [L]'
				])
			]
		notify: false

gulp.task 'watchify', ->
	bundle = ->
		gutil.log('Browserify: bundling')
		bundler.bundle()
			.on('error', ((err) -> gutil.log("Bundling error ::: "+err)))
			.pipe(source("main.js"))
			.pipe(gulp.dest("./build/development/js"))
			.pipe(browserSync.reload(stream: true, once: true))

	args = extend watchify.args,
		entries: './src/index.coffee'
		extensions: ['.coffee', '.jade']

	bundler = browserify args
	bundler = watchify(bundler)
	bundler.on 'update', bundle

	libs =
		jquery: './node_modules/jquery/dist/jquery'
		backbone: './node_modules/backbone/backbone'
		underscore: './node_modules/underscore/underscore'
	for own id, path of libs
		bundler.require path, expose: id

	bundler.transform 'coffeeify'
	bundler.transform 'jadeify'

	bundle()

gulp.task 'concatCss', ->
	gulp.src(cssFiles)
		.pipe(concat('libs.css'))
		.pipe(gulp.dest("./build/development/css"))
		.pipe(browserSync.reload(stream: true))

gulp.task 'stylus', ->
	gulp.src('./src/index.styl')
		.pipe(stylus(
			use: [nib()]
			errors: true
		))
		.pipe(rename("main.css"))
		.pipe(gulp.dest('./build/development/css'))
		.pipe(browserSync.reload({stream: true}))

gulp.task 'jade', ->
	gulp.src('./src/index.jade')
		.pipe(jade())
		.pipe(gulp.dest("./build/development"))
		.pipe(browserSync.reload({stream: true}))

gulp.task 'watch', ->
	gulp.watch cssFiles, ['concatCss']
	gulp.watch ['./src/**/*.styl'], ['stylus']
	gulp.watch ['./src/index.jade'], ['jade']

gulp.task 'default', ['server']