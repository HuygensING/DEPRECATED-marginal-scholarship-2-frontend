Form = require "../../../../../../models/form"

class MarginalsAnnotationtype extends Form

	defaults: ->
		quantification: ''
		remarks: ''
		type: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'type', (val) =>
			if val.hasOwnProperty 'title' then val.title else val

		[attrs, options] = @setter attrs, options, 'quantification', (val) =>
			if val.hasOwnProperty 'title' then val.title else val

		super

module.exports = MarginalsAnnotationtype