Backbone = require 'backbone'
_ = require 'underscore'
$ = require "jquery"
FS = require 'hibb-faceted-search'

config = require '../../models/config'

facetsTpl = require './facets.jade'
resultTpl = require './result.jade'
selectionCriteriaTpl = require './selection.jade'

facetNameMap =
	facet_s_codex_place_of_preservation: "Codex - Place of Preservation"
	facet_s_codex_origin_region: "Codex - Origin (Region)"
	facet_s_codex_origin_place: "Codex - Origin (Place)"
	facet_s_codex_origin_scriptorium: "Codex - Origin (Scriptorium)"
	facet_s_codex_provenance_region: "Codex - Provenance (Region)"
	facet_s_codex_provenance_place: "Codex - Provenance (Place)"
	facet_s_codex_provenance_scriptorium: "Codex - Provenance (Scriptorium)"
	facet_s_codex_marginal_space: "Codex - Marginal space %"
	facet_s_codex_script_type: "Codex - Script"
	facet_s_codex_pct_annotated_pages: "Codex - Annotated pages %"
	facet_s_codex_pct_blank_pages: "Codex - Blank pages %"
	facet_s_codex_top_marginfill_pct: "Codex - Most filled pages %"
	date_range: "Codex - Date"
	facet_s_text_title: "Text - Title"
	facet_s_text_author: "Text - Author"
	facet_s_text_period: "Text - Period"
	facet_s_text_type: "Text - Genre"
	facet_s_marg_typology: "Margin - Type"
	facet_s_margin_phenomenon: "Margin - Specific phenomena"
	margin_date_range: "Margin - Date"
	facet_s_margin_language: "Margin - Language"
	facet_s_margin_script_type: "Margin - Script type"
	facet_s_margin_origin_region: "Margin - Origin (Region)"
	facet_s_margin_origin_place: "Margin - Origin (Place)"
	facet_s_margin_origin_scriptorium: "Margin - Origin (Scriptorium)"
	facet_s_person_name: "Persons/places - Persons"
	facet_s_person_role: "Persons/places - Role"
	facet_s_place_region: "Persons/places - Region"
	facet_s_place_place: "Persons/places - Place"
	facet_s_place_scriptorium: "Persons/places - Scriptorium"

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

		@listenTo @facetedSearch, "results:render:finished", =>
			searchResult = @facetedSearch.searchResults.getCurrent()

			urls = searchResult.get("results").map (result) ->
				config.get('facsimileUrl') + "thumbnail_" + result["^codex"].substr(6) + ".jpg"
		
			Array.prototype.slice.call(@facetedSearch.el.querySelectorAll("li.result .img-container img")).map (img, index) ->
				img.onerror = ->
					img.src = "http://placehold.it/75x75"
				
				img.src = urls[index]

			if @facetedSearch.queryOptions.get("facetValues").length
				rtpl = selectionCriteriaTpl
					facetValues: @facetedSearch.queryOptions.get("facetValues")
					facetNameMap: facetNameMap
				page = $('<li class="result" />').html rtpl
				@$(".results .pages ul.page").prepend page

		@listenTo @facetedSearch, 'result:click', (codex) ->
			Backbone.history.navigate codex["^codex"], trigger: true

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"
		"click .reset": "_handleReset"
		"click .collapse": "_handleCollapse"

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

	_handleCollapse: do ->
		down = false
		
		(ev) ->
			@facetedSearch.facets.slideFacets down
			down = not down

module.exports = new Search()