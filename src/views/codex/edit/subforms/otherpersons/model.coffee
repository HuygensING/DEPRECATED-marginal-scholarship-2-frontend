Form = require "../../../../../models/form"

class OtherPerson extends Form

	defaults: ->
		certain: false
		pages: ''
		person: {}
		remarks: ''
		role: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'person', (val) ->
			if val.hasOwnProperty 'id' then id: val.id, type: 'person' else {}

		[attrs, options] = @setter attrs, options, 'role', (val) ->
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = OtherPerson