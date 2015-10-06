Backbone = require 'backbone'
_ = require "underscore"

Person = require '../models/person'

dropdownOptions = require "../views/codex/edit/form/dropdown/options"

class Persons extends Backbone.Collection
	
	model: Person

	initialize: ->
		_.extend @, dropdownOptions
		@dropdownOptionsInitialize()

	comparator: (person) ->
		person.get 'name'

module.exports = new Persons()