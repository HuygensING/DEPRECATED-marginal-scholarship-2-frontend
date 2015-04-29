Backbone = require 'backbone'
_ = require "underscore"

tpl = require "./index.jade"

class Interestingfor extends Backbone.View

	className: 'interestingfor'

	events: ->
		evs = {}

		evs['change input[data-view-id="'+@cid+'"]'] = 'inputChanged'

		evs

	inputChanged: (ev) ->
		if ev.currentTarget.checked
			@value.push ev.currentTarget.value
		else
			index = @value.indexOf ev.currentTarget.value
			@value.splice index, 1

		@triggerChange()

	initialize: (@options) ->
		super

		# Use stringify and parse to remove reference. The reference keeps the change event from firing.
		@value = JSON.parse JSON.stringify @options.value

		@render()

	render: ->
		rtpl = tpl
			viewId: @cid
			value: @value

		@$el.html rtpl

		@

	triggerChange: -> 
		value = JSON.parse JSON.stringify @value # Remove reference
		# console.log value
		@trigger 'change', value

module.exports = Interestingfor