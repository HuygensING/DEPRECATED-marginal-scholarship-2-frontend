Backbone = require 'backbone'

backendUrl = "http://demo17.huygens.knaw.nl/test-marginal-scholarship-backend/"

class Config extends Backbone.Model
	defaults: ->
		backendUrl: backendUrl
		personsUrl: backendUrl + "lists/person"
		fullPersonUrl: backendUrl + "persons"
		usersUrl: backendUrl + "users"
		textsUrl: backendUrl + "lists/text"
		fullTextUrl: backendUrl + "texts"
		localitiesUrl: backendUrl + "localityhierarchy"
		facsimileUrl: "https://cdn.huygens.knaw.nl/marginal-scholarship/images/"

module.exports = new Config()