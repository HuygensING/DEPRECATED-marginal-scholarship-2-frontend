asyncdata = ->

MultiForm = require '../../form/multi'

Tpl = require "./index.jade"

Model = require './model'

SubForms = 
	locality: require "../../form/locality"

class Provenance extends MultiForm

	id: 'provenance'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = SubForms

		super

	_formConfig: (data) ->
		locality:
			data: data.get("localities")

module.exports = Provenance