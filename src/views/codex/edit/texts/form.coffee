Form = require '../form'

SubForms =
	period: require '../form/autosuggest'
	contentTypes: require '../form/combolist'
	authors: require '../form/combolist'

Tpl = require "./form.jade"

class EditTextView extends Form

	className: 'form'

	# ### Initialize
	initialize: ->
		@tpl = Tpl
		@subforms = SubForms

		super

	_formConfig: (data) ->
		facetData = data.get("facetData")

		period: 
			data: facetData.textPeriod
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true
		contentTypes: 
			data: facetData.textContentType
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true
		authors:
			data: data.get("persons")
			# settings:
			# 	defaultAdd: false
			# 	getModel: (val, coll) ->
			# 		console.log val, coll
			# 		coll.get val
			# 	mutable: true

	# customAdd: (value, collection) ->
	# 	console.log arguments

	# # ### Render
	# postRender: ->
	# 	modal = new Views.Modal
	# 		title: "Edit text"
	# 		html: @el
	# 		submitValue: 'Save Text'
	# 		width: '80vw'

	# 	modal.on 'cancel', =>
	# 	modal.on 'submit', => 
	# 		@model.save null, 
	# 			success: (model) =>
	# 				@model.updateRev()
	# 				@trigger 'saved', @model
	# 				modal.messageAndFade 'success', 'Text saved!', 2000

module.exports = EditTextView