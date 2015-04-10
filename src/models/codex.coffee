Backbone = require "backbone"

config = require "./config"

class Codex extends Backbone.Model

	defaults: ->
		identifiers: []
		textUnits: []
		marginalsUnits: []
		marginUnits: []
		scripts: []
		URLs: []
		bibliographies: []
		pageLayouts: []
		origins: []
		provenances: []
		marginalQuantities: []
		layoutRemarks: ""
		quireStructure: ""
	
	url: ->
		config.get('backendUrl') + "codex/#{@id}/expandlinks"

module.exports = Codex