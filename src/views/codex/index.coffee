Backbone = require "backbone"

Pagination = require 'hibb-pagination'

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
		console.log @options
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

	# _renderPagination: (resultModel) ->
	# 	return
		
	# 	unless resultModel?
	# 		resultModel = searchView.facetedSearch.currentResult()
	# 		unless resultModel?
	# 			@pagination.destroy() if @pagination?
	# 			return

	# 	filtered = resultModel.get('results').filter (r) =>
	# 		r["^codex"].split('/')[1] is @options.id
	# 	console.log filtered
	# 	if filtered.length > 0
	# 		index = resultModel.get('results').indexOf(filtered[0])

	# 		@pagination = new Pagination
	# 			resultsStart: resultModel.get('start') + index
	# 			resultsPerPage: 1
	# 			resultsTotal: resultModel.get('numFound')
	# 			step10: false
	# 			showPageNames: ["codex", "codices"]

	# 		@pagination.on "change:pagenumber", (pageNumber) =>
	# 			codexId = resultModel.get("ids")[pageNumber - 1]
	# 			path = "codex/#{codexId}"

	# 			Backbone.history.navigate path, trigger: true
	# 			Backbone.trigger "remove-codex-view", @options.id, path

	# 		@$('.pagination').html @pagination.el
	# 	else
	# 		@pagination.destroy() if @pagination?


	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click aside img": "_handleFacsimileClick"

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