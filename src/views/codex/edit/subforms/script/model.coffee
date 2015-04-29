Form = require "../../../../../models/form"

class Script extends Form

	defaults: ->
		additionalRemarks: ''
		characteristics: ''
		characteristicsRemarks: ''
		handsCount: ''
		handsRange: ''
		scribeRemarks: ''
		scribes: []
		types: []
		typesRemarks: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'types', (val) ->
			if val.hasOwnProperty 'selected' then _.pluck(val.selected, 'title') else val

		super

module.exports = Script