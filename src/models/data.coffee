Backbone = require 'backbone'
$ = require 'jquery'

searchView = require "../views/search"
persons = require "../collections/persons"
Texts = require "../collections/texts"

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
			@trigger "loading:finished" if @isLoadingFinished()

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

		@fetchPersons()

		$.getJSON config.get("textsUrl"), (data) =>
			@set texts: new Texts(data, parse: true)

		$.getJSON config.get("localitiesUrl"), (data) =>
			@set localities: new Backbone.Collection(data)

	isLoadingFinished: ->
		Object.keys(@attributes).reduce (prev, next) =>
			prev && @get(next)?

	fetchPersons: ->
		$.getJSON config.get("personsUrl"), (data) =>
			persons.reset(data, parse: true)
			@set persons: persons

module.exports = new Data()