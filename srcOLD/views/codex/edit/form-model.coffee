Backbone = require 'backbone'

class Form extends Backbone.Model

	set: (attrs, options) ->
		# If attrs has namespace, ie: "someattr.someprop" get value for someattr and add someprop to someattr
		if _.isString(attrs) and attrs.split('.').length > 1
			splitted = attrs.split('.')

			oldValue = @get splitted[0]
			newValue = $.extend true, {}, oldValue # Use $.extend to trigger change

			if splitted[2]?
				newValue[splitted[1]][splitted[2]] = options
			else
				newValue[splitted[1]] = options

			attrs = splitted[0]
			options = newValue

		super

module.export = Form