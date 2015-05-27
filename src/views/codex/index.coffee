Backbone = require "backbone"
LoginComponent = require 'hibb-login'
# Pagination = require 'hibb-pagination'

tpl = require "./index.jade"

codices = require "../../collections/codices"
Codex = require "../../models/codex"
config = require "../../models/config"

searchView = require "../search"

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

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click aside img": "_handleFacsimileClick"
		"click svg.search": ->
			document.body.scrollTop = 0
			Backbone.history.navigate "", trigger: true
		"click svg.edit": ->
			Backbone.history.navigate "/codex/#{@options.pid}/edit", trigger: true

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