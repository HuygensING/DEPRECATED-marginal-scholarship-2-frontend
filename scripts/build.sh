#!/bin/sh

# Create dirs
rm -rf build/development
mkdir -p build/development/js
mkdir build/development/css
mkdir build/development/json

# Copy static content
cp static/json_parsed/* build/development/json
# rsync -avz ./static/hiloupe-images/ ./build/development/facsimiles
cp -r static/images build/development
cp -r static/thumbnails build/development
cp -r static/svg build/development

# Create server state
node_modules/.bin/babel-node scripts/server-state.js

# Build HTML
node_modules/.bin/jade \
	--no-debug \
	--obj build/development/json/server-state.json \
	--out build/development \
	src/index.jade

# # Copy HiLoupe CSS
# cp node_modules/hiloupe/dist/hiloupe.css build/development/css/hiloupe.css

# Build CSS
./node_modules/.bin/stylus \
	--use nib \
	--compress \
	--out build/development/css/index.css \
	src/stylus/index.styl

# Bundle JS libs
node_modules/.bin/browserify \
	--require classnames \
	--require react-router \
	--require react > build/development/js/libs.js

# Build JS
node_modules/.bin/browserify src/index.js \
	--external classnames \
	--external react-router \
	--external react \
	--standalone AnneFrank2 \
	--transform [ babelify --plugins object-assign ] \
	--verbose > build/development/js/index.js