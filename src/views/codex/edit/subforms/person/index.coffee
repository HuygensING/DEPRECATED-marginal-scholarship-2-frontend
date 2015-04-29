Model = require './model'

Views = 
	Modal: require 'hibb-modal'
	Form: require '../../form'

Tpl = require "./index.jade"

class Person extends Views.Form

	className: 'form'

	# ### Initialize
	initialize: ->
		@Model = Model
		@tpl = Tpl

		super

		# asyncdata (data) =>
		# 	@options.tplData = data

		# 	super

	# ### Render
	postRender: ->
		modal = new Views.Modal
			title: "Edit person"
			html: @el
			submitValue: 'Save Person'
			width: '720px'

		modal.on 'cancel', => @trigger 'cancel'
		modal.on 'submit', => 
			@model.save null,
				success: (model) =>
					model.updateRev()
					@trigger 'saved', model
					modal.messageAndFade 'success', 'Person saved!', 2000
		modal.on 'removed', =>
			@off()
			@remove()

module.exports = Person