Backbone = require 'backbone'
$ = require 'jquery'
_ = require "underscore"

searchView = require "../views/search"
persons = require "../collections/persons"
texts = require "../collections/texts"
users = require "../collections/users"

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
		users: null

	initialize: ->
		@listenToOnce searchView.facetedSearch, "change:results", (searchResult) =>
			facetData = {}
			for facet in searchResult.get('facets')
				if facetMap.hasOwnProperty(facet.name)
					displayName = facetMap[facet.name]
					optionList = facet.options.map (options) ->
						options.name

					facetData[displayName] = optionList
				# else
				# 	console.warn "Not found in facetMap: ", facet.name

			@set facetData: facetData

	fetch: (done) ->
		jqXHRPersons = $.getJSON config.get("personsUrl")
		jqXHRTexts = $.getJSON config.get("textsUrl")
		jqXHRLocalities = $.getJSON config.get("localitiesUrl")
		jqXHRUsers = $.getJSON config.get("usersUrl")

		$.when(jqXHRPersons, jqXHRTexts, jqXHRLocalities, jqXHRUsers).done (personsArgs, textsArgs, localitiesArgs, usersArgs) =>
			persons.reset(personsArgs[0], parse: true)
			texts.reset(textsArgs[0], parse: true)
			users.reset(usersArgs[0])

			@set
				persons: persons
				texts: texts
				localities: @_handleLocalities(localitiesArgs[0])

			done()

	_handleLocalities: (data) ->
		regions = []
		places = []
		scriptoria = []

		for region in data.regions
			regions.push region.name

			for place in region.places
				places.push place.name

				for scriptorium in place.scriptoria
					scriptoria.push scriptorium.name

		# Return an object with the data.
		data: data.regions
		regions: _.sortBy regions, _.identity
		places: _.sortBy places, _.identity
		scriptoria: _.sortBy scriptoria, _.identity

module.exports = new Data()