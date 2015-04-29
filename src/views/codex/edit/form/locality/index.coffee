Backbone = require 'backbone'
_ = require 'underscore'

tpl = require './index.jade'

class Locality extends Backbone.View

	className: 'locality'

	# ### Initialize
	initialize: (@options) ->
		@render()

	# ### Render
	render: ->
		@$el.html tpl()

		@

module.exports = Locality