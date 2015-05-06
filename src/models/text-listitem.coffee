BaseModel = require './base'
config = require "./config"

class TextListitem extends BaseModel

	parse: (attrs, options) ->
		attrs.title = attrs.label
		attrs.id = attrs.id.replace("/texts/", "")

		attrs

module.exports = TextListitem