Backbone = require "backbone"
LoginComponent = require "hibb-login"

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
		options.beforeSend = (xhr) ->
			if LoginComponent.getUser().isLoggedIn()
				xhr.setRequestHeader 'Authorization', LoginComponent.getUser().getToken()
			
			xhr.setRequestHeader 'Accept', "application/json"

		if method is 'read'
			options.url = model.url() + "/expandlinks"
		else if method is 'update'
			model = model.clone()

			model.set "textUnits", model.get("textUnits").map (textUnit) ->
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

			model.set "provenances", model.get("provenances").map (provenance) =>
				loc = provenance.locality

				provenance["^locality"] = [
					@_slug(loc.region)
					@_slug(loc.place)
					@_slug(loc.scriptorium)
				].join("-")
				
				delete provenance.locality

				provenance

			model.set "marginUnits", model.get("marginUnits").map (marginUnit) =>
				@_replaceLocality(origin) for origin in marginUnit.origins
				@_replacePerson(annotator) for annotator in marginUnit.annotators

				marginUnit

		super

	_replaceUser: (obj) ->
		obj["^user"] = "/users/#{obj.user.id}"
		delete obj.user

		obj

	_replacePerson: (obj) ->
		obj["^person"] = "/persons/#{obj.person.pid}"
		delete obj.person

		obj

	_replaceLocality: (obj) ->
		obj["^locality"] = [
			@_slug(obj.locality.region)
			@_slug(obj.locality.place)
			@_slug(obj.locality.scriptorium)
		].join("-")
		
		delete obj.locality

		obj

	_slug: (value) ->
		value = value.toLowerCase()
		value = value.replace(" ", "")
		value = value.replace("(", "")
		value = value.replace(")", "")
		value = value.replace(".", "")
		value = value.replace("-", "")

		value


module.exports = Codex