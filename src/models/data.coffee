Backbone = require 'backbone'
$ = require 'jquery'
_ = require "underscore"

searchView = require "../views/search"
persons = require "../collections/persons"
texts = require "../collections/texts"

config = require './config'

facetMap =
	"facet_s_person_role": "role"
	"facet_s_codex_origin_place": "originPlaces"
	"facet_s_codex_origin_region": "originRegions"
	"facet_s_codex_origin_scriptorium": "originScriptorium"
	"facet_s_codex_provenance_place": "provenancePlaces"
	"facet_s_codex_provenance_region": "provenanceRegions"
	"facet_s_codex_provenance_scriptorium": "provenanceScriptorium"
	"facet_s_codex_place_of_preservation": "locations"
	"facet_s_codex_script_type": "codexScriptType"
	"facet_s_margin_script_type": "marginScriptType"
	"facet_s_text_period": "textPeriod"
	"facet_s_margin_language": "languages"
	"facet_s_margin_phenomenon": "phenomenaType"
	"facet_s_marg_phenomena_quant": "phenomenaQuantification"
	"facet_s_marg_typology": "typologyType"
	"facet_s_marg_typology_quant": "typologyQuantification"
	"facet_s_text_state": "preservationState"

	# Other
	"facet_s_identifiers": "identifiers"
	"facet_s_person_name": "personName"
	"facet_s_region": "regions"
	# "facet_s_person": "persons"
	"facet_s_text_type": "textContentType"

class Data extends Backbone.Model
	defaults: ->
		facetData: null
		persons: null
		texts: null
		localities: null

	initialize: ->
		@once 'change:facetData change:persons change:texts', =>
			if @_isLoadingFinished()
				@done()

		@listenToOnce searchView.facetedSearch, "change:results", (searchResult) =>
			facetData = {}
			for facet in searchResult.get('facets')
				if facetMap.hasOwnProperty(facet.name)
					displayName = facetMap[facet.name]
					optionList = facet.options.map (options) ->
						options.name

					facetData[displayName] = optionList
				else
					console.warn "Not found in facetMap: ", facet.name

			@set facetData: facetData

	fetch: ->
		@_fetchPersons()
		@_fetchTexts()
		@_fetchLocalities()

	###
	# Returns true if all data has been loaded. Loading is finished when all attributes
	# have values.
	#
	# @returns {Boolean}
	###
	_isLoadingFinished: ->
		reducer = (prev, next) =>
			prev && @get(next)?

		Object.keys(@attributes).reduce reducer, true

	_fetchPersons: ->
		$.getJSON config.get("personsUrl"), (data) =>
			persons.reset(data, parse: true)
			@set persons: persons

	_fetchTexts: ->
		$.getJSON config.get("textsUrl"), (data) =>
			texts.reset(data, parse: true)
			@set texts: texts

	_fetchLocalities: ->
		$.getJSON config.get("localitiesUrl"), (data) =>
			regions = []
			places = []
			scriptoria = []

			for region in data.regions
				regions.push region.name

				for place in region.places
					places.push place.name

					for scriptorium in place.scriptoria
						scriptoria.push scriptorium.name

			data =
				data: data.regions
				regions: _.sortBy regions, _.identity
				places: _.sortBy places, _.identity
				scriptoria: _.sortBy scriptoria, _.identity

			@set localities: data


module.exports = new Data()