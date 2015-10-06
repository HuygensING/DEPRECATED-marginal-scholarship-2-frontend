_ = require "underscore"

BaseCollection = require "../collections/base"
BaseModel = require './base'
config = require "./config"

class Text extends BaseModel

	idAttribute: "pid"

	url: ->
		"#{config.get("fullTextUrl")}/#{@id}"

	defaults: ->
		title: ""
		period: ""
		contentTypes: []
		authors: []

	set: (attrs, options) ->
		[attrs, options] = @setter attrs, options, 'authors', (val) ->
			if val.hasOwnProperty("selected") then val.selected else val

		[attrs, options] = @setter attrs, options, 'contentTypes', (val) ->
			if val.hasOwnProperty("selected") then val.selected.map((s) -> s.id) else val

		super

	parse: (attrs, options) ->
		if attrs?.hasOwnProperty("authors")
			attrs.authors = new BaseCollection attrs.authors.map (author) ->
				id: author.person.pid
				title: author.person.name

		attrs

	sync: (method, model, options) ->
		if method is "read"
			options.url = @url() + "/expandlinks"

		if method is "update"
			model = model.clone()

			model.set "authors", model.get("authors").map (author) ->
				id = if author.hasOwnProperty("pid") then author.pid else author.id
				"^person": "/persons/" + id

			if model.get("period").hasOwnProperty("title")
				model.set "period", model.get("period").title

		super

module.exports = Text