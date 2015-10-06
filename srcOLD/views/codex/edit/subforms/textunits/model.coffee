Form = require "../../../../../models/form"

class TextUnit extends Form

	defaults: ->
		explicit: ''
		incipit: ''
		pages: ''
		remarks: ''
		stateOfPreservation: ''
		stateOfPreservationRemarks: ''
		text: {}
		titleInCodex: ''

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'text', (val) ->
			if val.hasOwnProperty("pid")
				val = 
					id: val.pid
					type: 'text'
			else if val.hasOwnProperty("id") 
				val = 
					id: val.id
					type: 'text'

			val

		[attrs, options] = @setter attrs, options, 'stateOfPreservation', (val) ->
			if val.hasOwnProperty 'id' then val.title else val

		super

module.exports = TextUnit