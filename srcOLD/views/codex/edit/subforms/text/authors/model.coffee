Form = require "../../../../../../models/form"

class Author extends Form

	defaults: ->
		person: {}
		remarks: ''
		role: 'author'

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'person', (val) ->
			if val.hasOwnProperty 'id' then id: val.id, type: 'person' else {}

		super

module.exports = Author