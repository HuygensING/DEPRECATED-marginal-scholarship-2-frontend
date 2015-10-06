Form = require "../../../../../../models/form"

class Scribe extends Form

	defaults: ->
		pages: ''
		person: {}
		role: 'scribe'
		remarks: ''
		certain: false

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'person', (val) ->
			if val.hasOwnProperty 'id' then id: val.id, type: 'person' else {}

		super

module.exports = Scribe