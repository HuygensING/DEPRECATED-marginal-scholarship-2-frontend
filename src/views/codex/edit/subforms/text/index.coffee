Model = require './model'

Views = 
	Modal: require 'hibb-modal'
	Form: require '../../form'

SubForms =
	period: require '../../form/autosuggest'
	contentTypes: require '../../form/combolist'
	authors: require './authors'

Tpl = require "./index.jade"

# ## EditTextModal
class EditTextModal extends Views.Form

	className: 'form'

	# ### Initialize
	initialize: ->
		@Model = Model
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

	# ### Render
	postRender: ->
		modal = new Views.Modal
			title: "Edit text"
			html: @el
			submitValue: 'Save Text'
			width: '80vw'

		modal.on 'cancel', =>
		modal.on 'submit', => 
			@model.save null, 
				success: (model) =>
					@model.updateRev()
					@trigger 'saved', @model
					modal.messageAndFade 'success', 'Text saved!', 2000

module.exports = EditTextModal