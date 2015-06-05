Backbone = require "backbone"
LoginComponent = require 'hibb-login'
# Pagination = require 'hibb-pagination'

tpl = require "./index.jade"

codices = require "../../collections/codices"
Codex = require "../../models/codex"
config = require "../../models/config"

searchView = require "../search"

calcAspectRatio = (originalWidth, originalHeight, boxWidth, boxHeight) ->
	widthRatio = boxWidth / originalWidth
	heightRatio = boxHeight / originalHeight

	Math.min widthRatio, heightRatio

###
# @class
# @namespace Views
###
class CodexView extends Backbone.View
	###
	# @method
	# @construct
	# @param {Object} this.options
	###
	initialize: (@options) ->
		@codex = codices.get(@options.pid)

		if @codex?
			@render()
		else
			@codex = new Codex @options
			@codex.fetch
				success: =>
					codices.add @codex
					@render()
				error: =>
					console.error @options.pid, arguments
					throw new Error "Unable to fetch codex #{@options.pid}"

	###
	# @method
	###
	render: ->
		@$el.html tpl
			codex: @codex
			user: LoginComponent.getUser()

		file = @codex.id + ".jpg";
		src = config.get('facsimileUrl')+file;

		img = @el.querySelector("aside img")
		img.onerror = ->
			img.src = "http://placehold.it/100&text=."
		img.src = config.get('facsimileUrl') + @codex.id + ".jpg"

		if @options.sub?
			@_changeTab @options.sub

		for layout, index in @codex.get("pageLayouts")
			canvas = @el.querySelector("ul.layouts > li:nth-child(#{index + 1}) li.canvas canvas")
			ver = [layout.marginTop].concat(layout.blockHeights).concat(layout.marginBottom)
			hor = [layout.marginLeft].concat(layout.columnWidths).concat(layout.marginRight)
			@renderLayoutCanvas canvas, hor, ver

		@

	renderLayoutCanvas: (canvas, hor, ver) ->
		# canvas = @el.querySelector('ul.layouts > li:nth-child('+(index + 1)+")")
		# console.log index, canvas
		# # console.log canvas, hor, ver, index
		ctx = canvas.getContext '2d'

		totalWidth = hor.reduce (p, c) -> p + c
		totalHeight = ver.reduce (p, c) -> p + c

		aspectRatio = calcAspectRatio totalWidth, totalHeight, 100, 100


		canvasWidth = totalWidth*aspectRatio
		canvasHeight = totalHeight*aspectRatio

		canvas.width = canvasWidth
		canvas.height = canvasHeight

		ctx.clearRect 0, 0, canvasWidth, canvasHeight

		ctx.fillStyle = "rgb(200,200,200)"
		ctx.fillRect 0, 0, canvasWidth, canvasHeight

		# Draw horizontal areas
		filled = false
		left = 0
		hor.map (columnWidth) ->
			if filled
				ctx.fillStyle = "rgb(120,120,120)"
				ctx.fillRect left*aspectRatio, 0, columnWidth*aspectRatio, canvasHeight

			filled = !filled
			left += columnWidth

		# Draw vertical areas
		empty = true
		top = 0
		ver.map (rowHeight) ->
			if empty
				ctx.fillStyle = "rgb(200,200,200)"
				ctx.fillRect 0, top*aspectRatio, canvasWidth, rowHeight*aspectRatio

			empty = !empty
			top += rowHeight

	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click aside img": "_handleFacsimileClick"
		"click svg.search": ->
			document.body.scrollTop = 0
			Backbone.history.navigate "", trigger: true
		"click svg.edit": ->
			window.location = "/codex/#{@options.pid}/edit"
			# Backbone.history.navigate "/codex/#{@options.pid}/edit", trigger: true

	_handleTabClick: (ev) ->
		tab = ev.currentTarget.getAttribute("data-tab")
		@_changeTab tab

	_changeTab: (tab) ->
		@$('ul.tabs li').removeClass 'active'
		@$('ul.tabs li.tab[data-tab="'+tab+'"]').addClass 'active'
		@$("div.tab").removeClass 'active'
		@$("div.tab.#{tab}").addClass 'active'

		tab = "" if tab is "metadata"
		Backbone.history.navigate "codex/#{@options.pid}/#{tab}"

	_handleFacsimileClick: (ev) ->
		@$el.toggleClass 'small-facsimile'

module.exports = CodexView