Model = require './model'

Views =
	Person: require '../../person'
	MultiForm: require '../../../form/multi'
	SubForms:
		person: require '../../../form/autosuggest'

Mixins =
	PersonForm: require '../../person.form.mixin'

Tpl = require "./index.jade"

class TextAuthors extends Views.MultiForm

	className: 'authors'

	# ### Initialize
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
				mutable: true
				editable: true
				defaultAdd: false

	# # ### Events
	events: -> _.extend super, 
		'click .person-placeholder button.edit': 'editPerson'

	customAdd: (value, collection) ->
		@addPerson collection

module.exports = TextAuthors