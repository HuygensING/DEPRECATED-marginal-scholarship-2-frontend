asyncdata = ->

Model = require './model'

Views = 
	MultiForm: require '../../form/multi'
	SubForms:
		origins: require './origins'
		annotators: require './annotators'
		marginTypes: require './annotationtype'
		specificPhenomena: require './specificphenomena'
		languages: require '../../form/combolist'
		scriptTypes: require '../../form/combolist'
		bibliographies: require '../../form/editablelist'

Tpl = require "./index.jade"

class MarginUnits extends Views.MultiForm

	className: 'margin-units'

	initialize: ->
		@tpl = Tpl
		@subforms = Views.SubForms
		@Model = Model

		super

	_formConfig: (data) ->
		facetData = data.get("facetData")

		languages:
			data: facetData.languages
		scriptTypes:
			data: facetData.marginScriptType
		bibliographies:
			settings:
				inputClass: 'bull'

	# We want to start the form with an empty model if there are no models.
	preRender: -> @addForm() if @collection.length is 0

module.exports = MarginUnits