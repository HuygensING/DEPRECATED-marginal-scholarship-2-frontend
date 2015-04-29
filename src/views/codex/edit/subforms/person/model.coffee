Form = require "../../../../../models/form"
config = require '../../../../../models/config'

class Person extends Form
	
	idAttribute: '_id'

	url: -> config.baseURL + 'resources/person/' + @id
	
	defaults: ->
		activityDate: null
		birthDate: null
		deathDate: null
		name: ''
		type: 'person'

	updateRev: ->
		newRev = @get '^rev'
		newRev++
		@set '^rev', newRev

	sync: (method, model, options) ->
		if method is 'create'
			jqXHR = $.post
				url: config.baseURL + 'resources/persons'
				dataType: 'text'
				data: JSON.stringify model.toJSON()
			jqXHR.done (data, textStatus, jqXHR) =>
				if jqXHR.status is 201
					xhr = $.get url: jqXHR.getResponseHeader('Location')
					xhr.done (data, textStatus, jqXHR) =>
						@trigger 'sync'
						options.success data
			jqXHR.fail (response) => console.log 'fail', response
		else
			super

module.exports = Person