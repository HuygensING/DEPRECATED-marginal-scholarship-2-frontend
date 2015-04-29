asyncdata = ->

Model = require './model'

Views = 
	Form: require '../../form'
	SubForms:
		scribes: require './scribes'
		types: require '../../form/combolist'

Tpl = require "./index.jade"

class Script extends Views.Form

	className: 'script form'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = Views.SubForms

		super

	_formConfig: (data)->
		types:
			data: data.get("facetData").codexScriptType
			view: Views.SubForms.types

module.exports = Script