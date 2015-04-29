Model = require './model'

MultiForm = require '../../../form/multi'

Tpl = require "./index.jade"

SubForms =
	locality: require "../../../form/locality"
	# 'place.region': require '../../../form/autosuggest'
	# 'place.place': require '../../../form/autosuggest'

class MarginalsOrigins extends MultiForm

	className: 'origins'

	initialize: ->
		@tpl = Tpl
		@Model = Model
		@subforms = SubForms

		super

	_formConfig: (data) ->
		locality:
			data: data.get("localities")
		# origin:
		# 	data: data.get("lo")
		# 	settings:
		# 		getModel: (val, coll) -> coll.get val
		# 		mutable: true
		# 'place.place':
		# 	data: ["dummy"]
		# 	settings:
		# 		getModel: (val, coll) -> coll.get val
		# 		mutable: true

module.exports = MarginalsOrigins