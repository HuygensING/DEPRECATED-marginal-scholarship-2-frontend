_ = require "underscore"

Model = require './model'

Views =
	Person: require '../../person'
	MultiForm: require '../../../form/multi'
	SubForms:
		person: require '../../../form/autosuggest'

Mixins =
	PersonForm: require '../../person.form.mixin'

Tpl = require "../../persons.jade"

class MarginalsAnnotators extends Views.MultiForm

	className: 'annotators'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = Views.SubForms

		_.extend @, Mixins.PersonForm

		super


	_formConfig: (data) ->
		person: 
			data: data.get("persons")
			settings:
				editable: true
				mutable: true
				defaultAdd: false

	events: -> _.extend super, 
		'click button.edit': 'editPerson'

	# When the default add is overwritten, a 'customAdd' event is triggered
	# when the user clicks button.add. The event passes the filled in value
	# and the collection.
	customAdd: (value, collection) -> @addPerson collection

module.exports = MarginalsAnnotators