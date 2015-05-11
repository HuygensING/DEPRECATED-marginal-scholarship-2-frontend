Model = require './model'

MultiForm = require '../../form/multi'
SubForms =
	institute: require '../../form/autosuggest'

Tpl = require "./index.jade"

class Locations extends MultiForm

	className: 'locations'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = SubForms
		
		super

	_formConfig: (data) ->
		institute: 
			data: data.get("facetData").locations
			settings:
				getModel: (val, coll) ->
					coll.get val
				mutable: true
				inputClass: 'large'


module.exports = Locations