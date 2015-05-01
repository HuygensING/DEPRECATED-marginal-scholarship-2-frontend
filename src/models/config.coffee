Backbone = require 'backbone'

backendUrl = "http://demo17.huygens.knaw.nl/test-marginal-scholarship-backend/"
class Config extends Backbone.Model
	
	defaults: ->
		# backendUrl: "http://10.152.32.58:2015/"
		backendUrl: backendUrl
		fullPersonUrl: backendUrl + "persons"
		personsUrl: backendUrl + "lists/person"
		textsUrl: backendUrl + "lists/text"
		localitiesUrl: backendUrl + "localityhierarchy"
		facsimileUrl: "http://demo7.huygens.knaw.nl/test-marginal-scholarship-frontend/images/"

module.exports = new Config()