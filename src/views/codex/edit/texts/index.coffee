Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require "../../../../models/config"

data = require "../../../../models/data"
Text = require "../../../../models/text"
texts = require "../../../../collections/texts"

TextForm = require "./form"

tpl = require './index.jade'
formTpl = require './form.jade'


# ## Codex
# * TODO change Views.Form into mixin
class TextsView extends Backbone.View

	# ### Initialize
	initialize: (@options) ->
		titles = data.get("texts").map((model) -> model.get("title"))
		@_letters = @_generateAlphabet(titles)

		# @_persons = data.get("texts").models
		@_currentChar = null

		@listenTo texts, "reset", @render

		@render()

	render: (texts) ->
		@$el.html tpl
			letters: @_letters
			texts: @_filter()

		@

	events: ->
		"click ul.alphabet > li": "_handleFilter"
		"click ul.alphabet > li.all": "_handleFilterAll"
		"click ul.texts > li": "_handlePerson"

	_handleFilter: (ev) ->
		@_currentChar = ev.currentTarget.innerHTML
		@render()

	_handleFilterAll: (ev) ->
		@_currentChar = null
		@render()

	_filter: ->
		if @_currentChar?
			filteredPersons = data.get("texts").filter (text) =>
				text.get("title").toUpperCase().charAt(0) is @_currentChar
		else
			filteredPersons = data.get("texts").models

		filteredPersons

	_handlePerson: (ev) ->
		active = @el.querySelector("ul.texts li.active")
		activeId = active?.getAttribute("data-id")

		id = ev.currentTarget.getAttribute("data-id")

		return if activeId is id

		text = new Text pid: id
		text.fetch
			success: =>
				@_renderForm ev.currentTarget, text
			error: ->
				console.log 'neah'

	_renderForm: do ->
		form = null

		(target, model) ->
			destroy = =>
				form.destroy() 
				@$("ul.texts li.active").removeClass "active"

			destroy() if form?

			form = new TextForm
				model: model

			form.on 'save:success', (text) =>
				destroy()

				jqXHRTexts = $.getJSON config.get("textsUrl"), (data) ->
					texts.reset(data, parse: true)

				console.log text
				console.log texts.get(text.id)
				# data.fetchPersons()

			form.on 'cancel', => 
				destroy()

			@$(target).addClass "active"
			@$(target).append form.el


	_generateAlphabet: (arr) ->
		arr.reduce (prev, curr, index) ->
			if index is 1
				prev = [prev.charAt(0).toUpperCase()]
			
			firstChar = curr.charAt(0).toUpperCase()

			if prev.indexOf(firstChar) is -1
				prev.push firstChar

			prev

module.exports = TextsView
