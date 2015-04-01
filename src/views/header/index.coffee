Backbone = require 'backbone'

tpl = require './index.jade'

Tabs = require './tabs'

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

	renderTabs: (pages, route, options) ->
		@tabs.remove() if @tabs?

		@tabs = new Tabs
			pages: pages
			route: route
			options: options
		@$('.tabs').html @tabs.el

module.exports = new Header()