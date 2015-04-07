Backbone = require "backbone"

tpl = require "./index.jade"

codices = require "../../collections/codices"
Codex = require "../../models/codex"
config = require "../../models/config"
###
# @class
# @namespace Views
###
class CodexView extends Backbone.View
	###
	# @method
	# @construct
	# @param {Object} this.options
	###
	initialize: (@options) ->
		@codex = new Codex @options
		@codex.fetch
			success: => 
				@render()

		@render()
	
	###
	# @method
	###
	render: ->
		@$el.html tpl 
			codex: @codex
			facsimileUrl: config.get('facsimileUrl')

		@

	events: ->
		"click ul.tabs > li": "_handleTabClick"

	_handleTabClick: (ev) ->
		@$('ul.tabs li').removeClass 'active'
		@$(ev.currentTarget).addClass 'active'

		@$("div.tab").removeClass 'active'
		@$("div.tab.#{ev.currentTarget.getAttribute('data-tab')}").addClass 'active'

module.exports = CodexView