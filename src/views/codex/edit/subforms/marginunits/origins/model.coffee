Form = require "../../../../../../models/form"

class MarginalsOrigins extends Form

	defaults: ->
		place: 
			region: ''
			place: ''
			scriptorium: ''
		certain: false

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'place.region', (val) =>
			if val.hasOwnProperty 'id' then val.title else val

		[attrs, options] = @setter attrs, options, 'place.place', (val) =>
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = MarginalsOrigins