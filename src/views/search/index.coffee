Backbone = require 'backbone'
FS = require 'hibb-faceted-search'

config = require '../../models/config'

facetsTpl = require './facets.jade'

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
		fs = new FS
			el: @el
			baseUrl: config.get("backendUrl")
			searchPath: "search"
			results: true
			templates:
				facets: facetsTpl

		fs.search()

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"

	_handleTabClick: (ev) ->
		@$('ul.tabs li').removeClass 'active'
		@$(ev.currentTarget).addClass 'active'

		@$("div.tab").removeClass 'active'
		@$("div.tab.#{ev.currentTarget.getAttribute('data-tab')}").addClass 'active'



module.exports = Search