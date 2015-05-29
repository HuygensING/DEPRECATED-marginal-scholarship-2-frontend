Backbone = require "backbone"
_ = require 'underscore'

config = require '../../../models/config'

Codex = require '../../../models/codex'

LoginComponent = require "hibb-login"

Views = 
	Modal: require 'hibb-modal'
	Form: require './form'
	SubForms:
		locations: require './subforms/locations'
		identifiers: require './subforms/identifiers'
		provenances: require './subforms/provenance'
		pageLayouts: require './subforms/pagelayouts'
		textUnits: require './subforms/textunits'
		marginUnits: require './subforms/marginunits'
		# persons: require './subforms/otherpersons'
		script: require './subforms/script'
		interestingFor: require './subforms/interestingfor'
		bibliographies: require './form/editablelist'
		URLs: require './form/editablelist'
		origin: require './form/locality'

PersonsView = require "./persons"
TextsView = require "./texts"

generateID = (length) ->
		length = if length? and length > 0 then (length-1) else 7

		chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
		text = chars.charAt(Math.floor(Math.random() * 52)) # Start with a letter

		while length-- # Countdown is more lightweight than for-loop
			text += chars.charAt(Math.floor(Math.random() * chars.length))

		text

isObjectLiteral = (obj) ->
		return false if not obj? or typeof obj isnt "object"

		ObjProto = obj

		0 while Object.getPrototypeOf(ObjProto = Object.getPrototypeOf(ObjProto)) isnt null

		Object.getPrototypeOf(obj) is ObjProto

compareJSON = (current, changed) ->
	changes = {}

	for own attr, value of current
		changes[attr] = 'removed' unless changed.hasOwnProperty attr

	for own attr, value of changed
		if current.hasOwnProperty attr
			if _.isArray(value) or isObjectLiteral(value)
				changes[attr] = changed[attr] unless _.isEqual current[attr], changed[attr]
			else
				changes[attr] = changed[attr] unless current[attr] is changed[attr]
		else
			changes[attr] = 'added'

	changes

tpl = require './index.jade'

subPages = ["codex", "text", "margin", "persons", "texts"]

# ## Codex
# * TODO change Views.Form into mixin
class EditCodexView extends Views.Form

	id: 'codex'

	_formConfig: (data) ->
		facetData = data.get("facetData")

		origin:
			data: data.get("localities")
			# settings:
			# 	getModel: (val, coll) -> coll.get val
			# 	mutable: true
		# 'origin.place.place':
		# 	data: data.get("localities")
			# settings:
			# 	getModel: (val, coll) -> coll.get val
			# 	mutable: true
		bibliographies:
			settings:
				inputClass: 'large'
		URLs:
			settings:
				inputClass: 'large'

	# ### Initialize
	initialize: (@options) ->
		@Model = Codex
		@modelAttributes = pid: @options.pid
		
		@tpl = tpl
		@subforms = Views.SubForms

		user = LoginComponent.getUser()
		user.on "unauthorized", ->
			loginView = LoginComponent.getLoginView
				modal: true
				title: 'Login'
		
		super

	preRender: ->
		@loadUnsaved()

		@tplData.generateID = generateID
		@tplData.email = @model.getUserEmail()
		
		@listenTo @model, 'change', (model, options) =>
			console.log "CHANGED", model
			localStorage.setItem model.id, JSON.stringify model.toJSON() if model.id?
			@activateSaveButton()


	postRender: ->
		$dateinfo = @$ '#dateinfo'
		$dateinfo.appendCloseButton
			html: '<img src="/static/form/images/icon.close.png">'
			close: => $dateinfo.hide()

		@updatePagecount()
		@updateMargincount()

		@_renderPersons()
		@_renderTexts()

		@_goToSub()

	_goToSub: ->
		if subPages.indexOf(@options.sub) > -1
			@tabClicked @options.sub


	_renderTexts: ->
		texts = new TextsView()
		@$("div[data-tab=\"texts\"]").html texts.el

	_renderPersons: ->
		persons = new PersonsView()
		@$("div[data-tab=\"persons\"]").html persons.el

	# ### Events
	events: -> _.extend super,
		'click button.save': (ev) ->
			ev.preventDefault()
			ev.stopPropagation()
		'click button.save.active': 'saveCodex'
		'click button.cancel': 'cancelCodex'
		'click button.delete': 'deleteCodex'
		'click .dateinfo': 'toggleDateInfo'

		'keyup input': 'activateSaveButton'
		'keyup select': 'activateSaveButton'
		'keyup textarea': 'activateSaveButton'

		'keyup input[name="folia"]': 'updatePagecount'
		'keyup input[name="marginalQuantities.totalBlankPages"]': 'updatePagecount'
		'keyup input[name="marginalQuantities.firstPagesWithMarginals"]': 'updateMargincount'
		'keyup input[name="marginalQuantities.firstPagesConsidered"]': 'updateMargincount'
		'click li[data-tab]': 'tabClicked'


	tabClicked: (ev) ->
		if ev.hasOwnProperty("currentTarget")
			ev.stopPropagation()
			tabName = ev.currentTarget.getAttribute 'data-tab'
		else
			tabName = ev

		Backbone.history.navigate "/codex/#{@options.pid}/edit/#{tabName}"

		@$('[data-tab]').removeClass 'active'

		@$('[data-tab="'+tabName+'"]').addClass 'active'

	updatePagecount: ->
		numberOfPages = @el.querySelector('input[name="folia"]').value
		blankPages = @el.querySelector('input[name="marginalQuantities.totalBlankPages"]').value
		percentage = Math.round(blankPages / numberOfPages * 100)
		count = "#{blankPages} out of #{numberOfPages} (#{percentage}%)"

		@el.querySelector('td.pagecount').innerHTML = count if _.isFinite(percentage)
	
	updateMargincount: ->
		withMarginals = @el.querySelector('input[name="marginalQuantities.firstPagesWithMarginals"]').value
		consideredPages = @el.querySelector('input[name="marginalQuantities.firstPagesConsidered"]').value
		percentage = Math.round(withMarginals/consideredPages * 100)
		count = "#{withMarginals} out of #{consideredPages} (#{percentage}%)"

		@el.querySelector('td.margincount').innerHTML = count if _.isFinite(percentage)

	saveCodex: (ev) ->
		ev.preventDefault()
		ev.stopPropagation()

		jqXHR = @model.save [], dataType: 'text'
		jqXHR.done (data, textStatus, xhr) =>
			if @model.isNew()
				# Get the ID from the response header and set to model.
				@model.set '_id', xhr.getResponseHeader('Location').split('/').pop()
				# Update URL.
				@publish 'navigate', 'codex/'+@model.id

			# Update the revision number.
			# @model.updateRev()

			# The model is saved to the server so unsaved attributes in localStorage can be removed.
			localStorage.removeItem @model.id

			@$('button.save').html 'Saved'
			@$('button.save').removeClass 'active'

			@trigger 'saved'

	cancelCodex: (ev) ->
		ev.preventDefault()
		ev.stopPropagation()

		localStorage.clear()
		Backbone.history.navigate "/codex/#{@options.pid}", trigger: true

	deleteCodex: (ev) ->
		if window.confirm 'You are about to delete Codex: '+@model.id
			jqXHR = @model.destroy()
			jqXHR.done (data, textStatus, xhr) =>
				url = if document.referrer isnt window.location.href and document.referrer isnt '' then document.referrer else '/view/codices'
				window.location = url

	toggleDateInfo: (ev) ->
		$target = $ ev.currentTarget
		targetPosition = $target.offset()
		
		$dateinfo = @$ '#dateinfo'

		newLeft = targetPosition.left + 40
		newTop = targetPosition.top - $dateinfo.height()/2

		newPos = false

		if $dateinfo.offset().top isnt newTop
			$dateinfo.css 'left', newLeft
			$dateinfo.css 'top', newTop
			newPos = true

		if $dateinfo.is(':hidden') or newPos
			$dateinfo.fadeIn('fast')
		else
			$dateinfo.hide()

	# ## Methods

	activateSaveButton: ->
		@$('button.save').addClass 'active'
		@$('button.save').html 'Save'

	# If localStorage has an item with the model's ID, there are unsaved changes.
	# Show a modal where the user can choose if the changes should be saved or discarded.
	loadUnsaved: ->
		# Return false if there isn't a localStorage item with the model's ID.
		return false unless localStorage.getItem(@model.id)?

		unsavedAttrs = JSON.parse localStorage.getItem @model.id

		changed = compareJSON @model.attributes, unsavedAttrs

		modal = new Views.Modal
			title: "There are unsaved changes!"
			html: "<pre>#{JSON.stringify(changed, null, 2)}</pre>"
			cancelValue: 'Discard changes'
			submitValue: 'Save changes'

		modal.on 'cancel', => localStorage.removeItem @model.id
		modal.on 'submit', => 
			@model.set unsavedAttrs

			# Render the form when the async @saveCodex is finished
			@on 'saved', @render, @
			@saveCodex()

			modal.messageAndFade 'success', "Saved changes to codex #{@model.id}.", 2000

	# fillForm: ->
	# 	@$('input').each (index, input) =>

	# 		if $(input).attr('type') is 'checkbox'
	# 			checked = if Math.random() < 0.5 then true else false
	# 			$(input).prop 'checked', checked
	# 		else
	# 			$(input).val generateID(4)
				
	# 		$(input).trigger 'change'

	# 	@$('textarea').each (index, textarea) =>
	# 		$(textarea).val generateID(12)
	# 		$(textarea).trigger 'change'

	# 	@$('select').each (index, select) =>
	# 		index = Math.floor(Math.random()*select.options.length)
	# 		option = select.options[index]
	# 		$(select).val option.value

	# 		$(select).trigger 'change'

	# 	@$('.invalid').each (index, invalid) =>
	# 		$(invalid).val 3
	# 		$(invalid).trigger 'change'

module.exports = EditCodexView