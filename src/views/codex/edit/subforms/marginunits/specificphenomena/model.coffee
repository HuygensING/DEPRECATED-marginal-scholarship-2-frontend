Form = require "../../../../../../models/form"

class MarginalsSpecificphenomena extends Form				

	defaults: ->
		type: ''
		quantification: ''
		remarks: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'type', (val) =>
			if val.hasOwnProperty 'title' then val.title else val

		[attrs, options] = @setter attrs, options, 'quantification', (val) =>
			if val.hasOwnProperty 'title' then val.title else val

		super

module.exports = MarginalsSpecificphenomena