_ = require "underscore"

asyncdata = ->

Model = require './model'

Mixins =
	PersonForm: require '../person.form.mixin'

Views =
	PersonForm: require '../person'
	MultiForm: require '../../form/multi'
	SubForms:
		person: require '../../form/autosuggest'
		role: require '../../form/autosuggest'

Tpl = require "./index.jade"

class OtherPersons extends Views.MultiForm

	className: 'otherpersons form'


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
		role: 
			data: data.get("facetData").role
			settings:
				getModel: (val, coll) -> coll.find (model) -> model.id is val
				mutable: true

	events: -> _.extend super, 
		'click button.edit': 'editPerson'

	# When the default add is overwritten, a 'customAdd' event is triggered
	# when the user clicks button.add. The event passes the filled in value
	# and the collection.
	customAdd: (value, collection) ->
		@addPerson collection

module.exports = OtherPersons