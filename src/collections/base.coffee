Backbone = require 'backbone'

class Base extends Backbone.Collection

	removeById: (id) ->
		model = @get id
		@remove model

module.exports = Base