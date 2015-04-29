asyncdata = ->

Model = require './model'

MultiForm = require '../../../form/multi'

Subforms = 
	type: require '../../../form/autosuggest'
	quantification: require '../../../form/autosuggest'

Tpl = require "./index.jade"

class MarginalsSpecificPhenomena extends MultiForm

	className: 'specificphenomena'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = Subforms

		super
	
	_formConfig: (data) ->
		facetData = data.get("facetData")

		type: 
			data: facetData.phenomenaType
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true
		quantification: 
			data: facetData.phenomenaQuantification
			settings:
				getModel: (val, coll) -> coll.get val
				mutable: true


module.exports = MarginalsSpecificPhenomena