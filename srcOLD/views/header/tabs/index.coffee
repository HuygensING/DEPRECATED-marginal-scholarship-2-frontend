Backbone = require 'backbone'

tpl = require './index.jade'

###
# @class
# @namespace Views
###
class Tabs extends Backbone.View
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

		@$el.html tpl 
			codices: @options.pages.codices
			route: @options.route
			routeOptions: @options.options

		@

	events: ->
		"click li": "_handleLiClick"
		"click li small": "_handleSmallClick"

	_handleLiClick: (ev) ->
		Backbone.history.navigate ev.currentTarget.getAttribute('data-path'), trigger: true

	_handleSmallClick: (ev) ->
		ev.stopPropagation()

		id = ev.currentTarget.getAttribute("data-id")
		Backbone.trigger "remove-codex-view", id

module.exports = Tabs