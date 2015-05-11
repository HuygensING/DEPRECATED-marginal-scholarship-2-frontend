Model = require './model'

MultiForm = require '../../form/multi'
SubForms =
	type: require '../../form/autosuggest'

Tpl = require "./index.jade"

class Identifiers extends MultiForm

	className: 'identifiers'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = SubForms

		super

	_formConfig: (data) ->
		type: 
			data: ["(empty)", "Bergmann", "Bischoff", "CLA", "KIH"] #tmp
			settings:
				getModel: (val, coll) ->
					coll.get val
				mutable: true

module.exports = Identifiers