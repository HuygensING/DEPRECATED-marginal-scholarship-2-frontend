Backbone = require "backbone"

config = require "./config"

class Codex extends Backbone.Model

	idAttribute: "pid"

	defaults: ->
		identifiers: []
		textUnits: []
		# marginalsUnits: []
		marginUnits: []
		script: {}
		URLs: []
		bibliographies: []
		pageLayouts: []
		# origin: {}
		provenances: []
		marginalQuantities: []
		layoutRemarks: ""
		quireStructure: ""
	
	url: ->
		config.get('backendUrl') + "codex/#{@id}"

	getUserEmail: ->
		console.error "NOT IMPLEMENTED"

	sync: (method, model, options) ->
		if method is 'read'
			options.url = model.url() + "/expandlinks"
		# else if method is 'update'
		# 	options.url = model.url()
		# 	model = model.clone()
		# 	model.unset 'id'

		super

module.exports = Codex