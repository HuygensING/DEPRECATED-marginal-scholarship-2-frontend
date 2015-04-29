Backbone = require 'backbone'
_ = require 'underscore'
FS = require 'hibb-faceted-search'

config = require '../../models/config'

facetsTpl = require './facets.jade'
resultTpl = require './result.jade'

###
# @class Search
# @namespace Views
###
class Search extends Backbone.View

	className: "faceted-search-placeholder"

	###
	# @method
	# @construct
	# @param {Object} this.options
	###
	initialize: (@options) ->
		@render()
	
	###
	# @method
	###
	render: ->
		@facetedSearch = new FS
			el: @el
			baseUrl: config.get("backendUrl")
			searchPath: "search"
			results: true
			showMetadata: false
			textSearch: 'none'
			templates:
				facets: facetsTpl
				result: resultTpl
			templateData:
				result:
					facsimileUrl: config.get('facsimileUrl')
			showPageNames: ["page", "pages"]

		@facetedSearch.search()

		@listenTo @facetedSearch, 'result:click', (codex) ->
			Backbone.history.navigate codex["^codex"], trigger: true

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click .reset": "_handleReset"

	_handleTabClick: (ev) ->
		@$('ul.tabs li').removeClass 'active'
		@$(ev.currentTarget).addClass 'active'

		@$("div.tab").removeClass 'active'
		@$("div.tab.#{ev.currentTarget.getAttribute('data-tab')}").addClass 'active'

		for viewName, view of @facetedSearch.facets.views
			if viewName.substr(-6) is "_range"
				view.postRender()

	_handleReset: ->
		@facetedSearch.reset()



module.exports = new Search()