Backbone = require 'backbone'

class Config extends Backbone.Model
	
	defaults: ->
		backendUrl: "http://demo17.huygens.knaw.nl/test-marginal-scholarship-backend/"
		facsimileUrl: "http://demo7.huygens.knaw.nl/test-marginal-scholarship-frontend/images/"

module.exports = new Config()