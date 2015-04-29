Backbone = require 'backbone'

class Base extends Backbone.Model

	###
	# Helper function to override the setting of an attribute in @set
	# @set can take a key-value pair as attrs=key, options=value or attrs={key:value}, options={}
	# setter changes the attrs and options (and returns them) according to what key-value pair "system" is given
	#
	# @param attrs String or Object the original attrs passed to @set
	# @param options String or Object the original options passed to @set
	# @param attr String the attribute which value to change
	# @param alterValue Function alters the value of attr, takes value (attrs[attr] or options) as param and returns the new val
	#
	# @returns Array containing attrs and options
	###
	setter: (attrs, options, attr, alterValue) ->
		if attrs.hasOwnProperty attr
			attrs[attr] = alterValue attrs[attr]

		if attrs is attr
			options = alterValue options

		[attrs, options]

module.exports = Base