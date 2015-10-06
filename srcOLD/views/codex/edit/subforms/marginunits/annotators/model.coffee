Form = require "../../../../../../models/form"

class Annotator extends Form

	defaults: ->
		pages: ''
		person: {}
		role: 'annotator'
		remarks: ''
		certain: false

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'person', (val) ->
			if val.hasOwnProperty 'pid' then id: val.pid, type: 'person' else {}

		super

module.exports = Annotator