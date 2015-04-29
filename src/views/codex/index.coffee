Backbone = require "backbone"

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
		@codex = codices.get(@options.id)

		if @codex?
			@render()
		else
			@codex = new Codex @options
			@codex.fetch
				success: =>
					codices.add @codex
					@render()

		# @listenTo searchView.facetedSearch, 'change:results', @_renderPagination

		# @render()
	
	###
	# @method
	###
	render: ->
		@$el.html tpl 
			codex: @codex
			facsimileUrl: config.get('facsimileUrl')

		# @_renderPagination()

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click aside img": "_handleFacsimileClick"
		"click svg.search": ->
			document.body.scrollTop = 0
			Backbone.history.navigate "", trigger: true
		"click svg.edit": ->
			Backbone.history.navigate "/codex/#{@options.id}/edit", trigger: true

	_handleTabClick: (ev) ->
		@$('ul.tabs li').removeClass 'active'
		@$(ev.currentTarget).addClass 'active'

		@$("div.tab").removeClass 'active'
		@$("div.tab.#{ev.currentTarget.getAttribute('data-tab')}").addClass 'active'

		tab = ev.currentTarget.getAttribute("data-tab")
		tab = "" if tab is "metadata"
		Backbone.history.navigate "codex/#{@options.id}/#{tab}"

	_handleFacsimileClick: (ev) ->
		@$el.toggleClass 'small-facsimile'

module.exports = CodexView