Form = require "../../../../../models/form"

class Provenance extends Form

	defaults: ->
		date: ''
		dateInfo: ''
		place:
			region: ''
			place: ''
			scriptorium: ''
		certain: false
		remarks: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'place.region', (val) =>
			if val.hasOwnProperty 'id' then val.title else val

		[attrs, options] = @setter attrs, options, 'place.place', (val) =>
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = Provenance