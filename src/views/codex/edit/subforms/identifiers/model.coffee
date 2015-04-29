Form = require "../../../../../models/form"

class Identifier extends Form

	defaults: ->
		type: ''
		identifier: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'type', (val) ->
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = Identifier