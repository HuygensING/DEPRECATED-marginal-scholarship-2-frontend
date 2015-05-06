_ = require "underscore"

asyncdata = ->

Model = require './model'

Views =
	Modal: require 'hibb-modal'
	TextForm: require '../text'
	MultiForm: require '../../form/multi'
	SubForms:
		text: require '../../form/autosuggest'
		stateOfPreservation: require '../../form/autosuggest'

Tpl = require "./index.jade"

class TextUnits extends Views.MultiForm

	id: 'textunits'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = Views.SubForms

		super

	_formConfig: (data) ->
		text: 
			data: data.get("texts")
			settings:
				inputClass: 'large'
				getModel: (val, coll) ->
					coll.get val.id
				# editable: true
				# mutable: true
				# defaultAdd: false
		stateOfPreservation: 
			data: data.get("facetData").preservationState
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true


	# We want to start the form with an empty model if there are no models.
	preRender: -> @addForm() if @collection.length is 0

	events: -> _.extend super, 
		'click .text-placeholder button.edit': 'editText'
		# 'click .text-placeholder button.add': 'addText'

	# When the default add is overwritten, a 'customAdd' event is triggered
	# when the user clicks button.add. The event passes the filled in value
	# and the collection.
	customAdd: (value, collection) ->
		textForm = new Views.TextForm()

		# When the modal is submitted, the text is saved to server and triggers a 'saved' event
		textForm.once 'saved', (textModel) =>
			collection.add 
				id: textModel.id
				title: @getTitle textModel

			@render()

	editText: (ev) ->
		# The event is triggered in a MultiForm, so we have to find the model we clicked first.
		modelID = @$(ev.currentTarget).parents('.model').attr 'data-cid'
		model = @collection.get modelID

		# The model holds the textID.
		textID = model.get('text').id

		# If the user hasnt selected a text, the textID is undefined and we do nothing.
		if textID?
			# Instantiate the text form (loaded in a modal)
			textForm = new Views.TextForm
				value:
					_id: textID

			# When the modal is submitted, the text is saved to server and triggers a 'saved' event
			textForm.once 'saved', (textModel) =>
				# Get the simple version of the text and update the title (for the autosuggest)
				textSimple = @data.textsSimple.get textID
				textSimple.set 'title', @getTitle textModel

				@render()


	getTitle: (textModel) ->
		# Get the title of the person from async data
		if textModel.get('authors').length > 0
			# Create an array of author names, extracted from async data
			authors = _.map textModel.get('authors'), (author) => 
				p = @data.persons.get author.person.id
				p.get('title')

			personTitle = authors.join(', ')
		else
			personTitle = '(unknown author)'

		personTitle + ' - ' + textModel.get('title')

module.exports = TextUnits