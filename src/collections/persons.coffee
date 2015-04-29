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

	# parse: (attrs) ->
	# 	attrs.name = attrs.label
	# 	console.log attrs.label

	# 	attrs

module.exports = Persons