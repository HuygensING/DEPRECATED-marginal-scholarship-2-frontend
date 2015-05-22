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
		else if method is 'update'
			model = model.clone()

			model.set "textUnits", model.get("textUnits").map (textUnit) ->
				console.log textUnit.text
				textUnit["^text"] = "/texts/#{textUnit.text.pid}"
				delete textUnit.text

				textUnit

			origin = model.get("origin")
			loc = origin.locality
			origin["^locality"] = [
				@_slug(loc.region)
				@_slug(loc.place)
				@_slug(loc.scriptorium)
			].join("-")
			delete origin.locality
			model.set "origin", origin

			model.set "userRemarks", model.get("userRemarks").map (userRemark) ->
				userRemark["^user"] = "/users/#{userRemark.user.id}"
				delete userRemark.user

				userRemark

		super

	_slug: (value) ->
		value = value.toLowerCase()
		value = value.replace(" ", "")
		value = value.replace("(", "")
		value = value.replace(")", "")
		value = value.replace(".", "")
		value = value.replace("-", "")

		value


module.exports = Codex