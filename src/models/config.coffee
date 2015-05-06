Backbone = require 'backbone'

backendUrl = "http://demo17.huygens.knaw.nl/test-marginal-scholarship-backend/"
class Config extends Backbone.Model
	
	defaults: ->
		# backendUrl: "http://10.152.32.58:2015/"
		backendUrl: backendUrl
		personsUrl: backendUrl + "lists/person"
		fullPersonUrl: backendUrl + "persons"
		textsUrl: backendUrl + "lists/text"
		fullTextUrl: backendUrl + "texts"
		localitiesUrl: backendUrl + "localityhierarchy"
		facsimileUrl: "http://demo7.huygens.knaw.nl/test-marginal-scholarship-frontend/images/"

module.exports = new Config()