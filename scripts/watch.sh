#!/bin/sh

# Watch HTML
node_modules/.bin/jade \
	--no-debug \
	--obj build/development/json/server-state.json \
	--out build/development \
	--watch \
	src/index.jade &

# Build CSS
./node_modules/.bin/stylus \
	--use nib \
	--compress \
	--out build/development/css/index.css \
	--watch \
	src/stylus/index.styl &

# Watch JS
# node_modules/.bin/watchify src/index.js \
# 	--external classnames \
# 	--external react-router \
# 	--external underscore \
# 	--external react \
# 	--outfile build/development/js/index.js \
# 	--standalone AnneFrank2 \
# 	--verbose

node_modules/.bin/watchify src/index.js \
	--external classnames \
	--external react \
	--external react-router \
	--outfile build/development/js/index.js \
	--standalone AnneFrank2 \
	--transform [ babelify --plugins object-assign ] \
	--verbose