Backbone = require 'backbone'

tpl = require './index.jade'

###
# @class Header
# @namespace Views
###
class Header extends Backbone.View
	###
	# @method
	# @construct
	# @param {Object} this.options
	###
	initialize: (@options) ->
		@render()
	
	###
	# @method
	###
	render: ->
		@$el.html tpl()

		@

module.exports = Header