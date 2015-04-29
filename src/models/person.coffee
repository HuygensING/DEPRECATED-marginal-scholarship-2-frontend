BaseModel = require './base'

class Person extends BaseModel

	parse: (attrs) ->
		myAttrs =
			id: attrs.id.replace("/persons/", "")
			title: attrs.label

		myAttrs

module.exports = Person