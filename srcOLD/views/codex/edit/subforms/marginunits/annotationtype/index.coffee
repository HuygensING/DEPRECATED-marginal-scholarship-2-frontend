Model = require './model'

MultiForm = require '../../../form/multi'
Subforms = 
	type: require '../../../form/autosuggest'
	quantification: require '../../../form/autosuggest'

Tpl = require "./index.jade"

class MarginalsAnnotationtype extends MultiForm

	className: 'typology'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = Subforms

		super

	_formConfig: (data) ->
		facetData = data.get("facetData")
		
		type: 
			data: facetData.typologyType
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true
		quantification: 
			data: facetData.typologyQuantification
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true

module.exports = MarginalsAnnotationtype