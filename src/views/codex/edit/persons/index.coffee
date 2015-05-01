Backbone = require 'backbone'
_ = require 'underscore'

data = require "../../../../models/data"
Person = require "../../../../models/person"
persons = require "../../../../collections/persons"

Form = require "../form"

tpl = require './index.jade'
formTpl = require './form.jade'


# ## Codex
# * TODO change Views.Form into mixin
class PersonsView extends Backbone.View

	# ### Initialize
	initialize: (@options) ->
		titles = data.get("persons").map((model) -> model.get("title"))
		@_letters = @_generateAlphabet(titles)

		# @_persons = data.get("persons").models
		@_currentChar = null

		@listenTo persons, "reset", @render

		@render()

	render: (persons) ->

		# console.log @_persons.filter((p) -> 
		# 	p.get("title").indexOf("Nicetas") > -1)[0].get("title")

		@$el.html tpl
			letters: @_letters
			persons: @_filter()

		@

	events: ->
		"click ul.alphabet > li": "_handleFilter"
		"click ul.alphabet > li.all": "_handleFilterAll"
		"click ul.persons > li": "_handlePerson"

	_handleFilter: (ev) ->
		@_currentChar = ev.currentTarget.innerHTML
		@render()

	_handleFilterAll: (ev) ->
		@_currentChar = null
		@render()

	_filter: ->
		if @_currentChar?
			filteredPersons = data.get("persons").filter (person) =>
				person.get("title").toUpperCase().charAt(0) is @_currentChar
		else
			filteredPersons = data.get("persons").models

		filteredPersons

	_handlePerson: (ev) ->
		id = ev.currentTarget.getAttribute("data-id")
		person = new Person pid: id
		person.fetch
			success: =>
				@_renderForm person
			error: ->
				console.log 'neah'

	_renderForm: do ->
		form = null

		(model) ->
			form.destroy() if form?

			form = new Form
				tpl: formTpl
				model: model

			form.on 'save:success', =>
				form.destroy()
				data.fetchPersons()

			form.on 'cancel', => 
				form.destroy()

			@$(".form-container").html form.el


	_generateAlphabet: (arr) ->
		arr.reduce (prev, curr, index) ->
			if index is 1
				prev = [prev.charAt(0).toUpperCase()]
			
			firstChar = curr.charAt(0).toUpperCase()

			if prev.indexOf(firstChar) is -1
				prev.push firstChar

			prev

module.exports = PersonsView
