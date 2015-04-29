Form = require "../../../../../models/form"

class MarginUnit extends Form

	defaults: ->
		annotators: []
		bibliographies: []
		date: ''
		functionalAspects: ''
		generalObservations: ''
		handCount: ''
		identifier: ''
		languages: []
		origins: []
		pages: ''
		relativeDate: ''
		scriptTypes: []
		scriptsRemarks: ''
		specificPhenomena: []
		marginTypes: []
		typologyRemarks: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'languages', (val) ->
			if val.hasOwnProperty 'selected' then _.pluck(val.selected, 'title') else val

		[attrs, options] = @setter attrs, options, 'scripts', (val) ->
			if val.hasOwnProperty 'selected' then _.pluck(val.selected, 'title') else val

		super

module.exports = MarginUnit