Backbone = require 'backbone'
_ = require "underscore"

Text = require '../models/text-listitem'

dropdownOptions = require "../views/codex/edit/form/dropdown/options"

class Texts extends Backbone.Collection
	
	model: Text

	initialize: ->
		_.extend @, dropdownOptions
		@dropdownOptionsInitialize()

	comparator: (model) ->
		model.get 'title'

module.exports = new Texts()