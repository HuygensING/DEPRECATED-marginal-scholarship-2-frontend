# _ = require "underscore"

# config = require '../../../models/config'

# # cookie = require 'hilib/managers/cookie'

# Form = require "../../../models/form"

# class Codex extends Form

# 	# idAttribute: '_id'

# 	validation:
# 		'marginalQuantities.firstPagesWithMarginals':
# 			pattern: 'number'
# 			required: false	
# 		'marginalQuantities.firstPagesConsidered':
# 			pattern: 'number'
# 			required: false				
# 		'marginalQuantities.mostFilledPagePctage':
# 			pattern: 'number'
# 			required: false	
# 		# 'marginalQuantities.mostFilledPageDesignation':
# 		# 	pattern: 'number'
# 		# 	required: false				
# 		'marginalQuantities.totalBlankPages':
# 			pattern: 'number'
# 			required: false
# 		'folia':
# 			pattern: 'number'
# 			required: false
# 		'bookDimensions.width':
# 			pattern: 'number'
# 			required: false
# 		'bookDimensions.height':
# 			pattern: 'number'
# 			required: false

# 	defaults: ->
# 		# "_id": null
# 		"^rev": 0
# 		"^deleted": false
# 		"type": "codex"
# 		"locations": []
# 		"identifiers": []
# 		"examinationLevel": "Catalogue only"
# 		"thumbnailInfo": ""
# 		"contentSummary": ""
# 		"marginalsSummary": ""
# 		"marginalQuantities":
# 			"firstPagesWithMarginals": ""
# 			"firstPagesConsidered": ""
# 			"mostFilledPagePctage": ""
# 			"mostFilledPageDesignation": ""
# 			"totalBlankPages": ""
# 		"date":
# 			"date": ""
# 			"source": ""
# 		"origin":
# 			"place":
# 				"region": ""
# 				"place": ""
# 				"scriptorium": ""

# 			"remarks": ""
# 			"certain": false
# 		"provenance": []
# 		"dateAndLocaleRemarks": ""
# 		"bookDimensions":
# 			"width": ""
# 			"height": ""
# 		"pageLayouts": []
# 		"folia": ""
# 		"quireStructure": ""
# 		"layoutRemarks": ""
# 		"script":
# 			"types": []
# 			"typesRemarks": ""
# 			"characteristics": ""
# 			"characteristicsRemarks": ""
# 			"handsCount": ""
# 			"handsRange": ""
# 			"scribes": []
# 			"scribeRemarks": ""
# 			"additionalRemarks": ""
# 		"marginUnits": []
# 		"textUnits": []
# 		"interestingFor": []
# 		"userRemarks": {}
# 		"persons": []
# 		"bibliographies": []
# 		"URLs": []

# 	set: (attrs, options) ->
# 		[attrs, options] = @setter attrs, options, 'userRemarks', (val) =>
# 			# If val is a string, add val to userRemarks object
# 			if _.isString(val)
# 				prevVal = @get 'userRemarks'
# 				prevVal[@getUserEmail()] = val
# 				@trigger 'change', @ # Trigger change manually, because an update of a (referenced) object does not automatically
# 				return prevVal
# 			else
# 				return val

# 		[attrs, options] = @setter attrs, options, 'origin.place.region', (val) =>
# 			return if val.hasOwnProperty 'id' then val.title else ''

# 		[attrs, options] = @setter attrs, options, 'origin.place.place', (val) =>
# 			return if val.hasOwnProperty 'id' then val.title else ''

# 		super

# 	sync: (method, model, options) ->
# 		if method is 'create'
# 			options.url = "#{config.baseURL}resources/codexs"
# 		else if method is 'update'
# 			options.url = "#{config.baseURL}resources/codex/#{@id}"
# 		else if method is 'read'
# 			options.url = "#{config.baseURL}resources/codex/#{@id}"
# 		else if method is 'delete'
# 			options.url = "#{config.baseURL}resources/codex/#{@id}"

# 		super

# 	updateRev: ->
# 		newRev = @get '^rev'
# 		newRev++
# 		@set '^rev', newRev

# 	getUserEmail: ->
# 		console.error "NOT IMPLEMENTED"
# 		# cook = cookie.get 'ms-userinfo'
		
# 		# return false unless cook?
		
# 		# user = JSON.parse unescape cook
# 		# user._id.replace /\./g, '_'

# module.exports = Codex