Form = require "../../../../../models/form"

class Location extends Form

	defaults: ->
		institute: ''
		shelfmark: ''
		pages: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'institute', (val) ->
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = Location