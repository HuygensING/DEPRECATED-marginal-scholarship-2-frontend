BaseModel = require './base'
config = require "./config"

class Person extends BaseModel

	idAttribute: "pid"

	url: ->
		"#{config.get("fullPersonUrl")}/#{@id}"

	defaults: ->
		name: ""
		activityDate: ""
		birthDate: ""
		deathDate: ""

	parse: (attrs, options) ->
		# If parsing for the collection ...
		if options.collection
			return {
				id: attrs.id.replace("/persons/", "")
				title: attrs.label
			}

		attrs

module.exports = Person