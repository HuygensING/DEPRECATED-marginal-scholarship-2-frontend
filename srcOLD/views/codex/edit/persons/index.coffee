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

		# @listenTo persons, "reset", @render

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
		active = @el.querySelector("ul.persons li.active")
		activeId = active?.getAttribute("data-id")

		id = ev.currentTarget.getAttribute("data-id")

		return if activeId is id

		person = new Person pid: id
		person.fetch
			success: =>
				@_renderForm ev.currentTarget, person
			error: ->
				console.error "Fetching Person #{id} failed"

	_renderForm: do ->
		form = null

		(target, model) ->
			destroy = =>
				form.destroy() 
				@$("ul.persons li.active").removeClass "active"

			destroy() if form?

			form = new Form
				tpl: formTpl
				model: model

			form.on 'save:success', (person) =>
				destroy()

				persons.get(person.id).set person.attributes
				persons.get(person.id).set
					title: person.get("name")

				@render()

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

module.exports = PersonsView
