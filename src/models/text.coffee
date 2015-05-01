BaseModel = require './base'

class Text extends BaseModel

	parse: (attrs) ->
		myAttrs =
			id: attrs.id.replace("/texts/", "")
			title: attrs.label

		myAttrs


module.exports = Text

# $ = require 'jquery'

# Form = require './form'
# config = require './config'

# class Text extends Form

# 	defaults:
# 		period: ''
# 		contentTypes: []
# 		authors: []

# 	url: -> config.baseURL + 'resources/text/' + @id

# 	idAttribute: '_id'

# 	updateRev: ->
# 		newRev = @get '^rev'
# 		newRev++
# 		@set '^rev', newRev

# 	set: (attrs, options) ->
# 		[attrs, options] = @setter attrs, options, 'period', (val) =>
# 			if val.hasOwnProperty 'id' then val.title else val

# 		[attrs, options] = @setter attrs, options, 'contentTypes', (val) ->
# 			if val.hasOwnProperty 'selected' then _.pluck(val.selected, 'title') else val

# 		super

# 	sync: (method, model, options) ->
# 		if method is 'create'
# 			jqXHR = $.post
# 				url: config.baseURL + 'resources/texts'
# 				dataType: 'text'
# 				data: JSON.stringify model.toJSON()
# 			jqXHR.done (data, textStatus, jqXHR) =>
# 				if jqXHR.status is 201
# 					xhr = $.get url: jqXHR.getResponseHeader('Location')
# 					xhr.done (data, textStatus, jqXHR) =>
# 						@trigger 'sync'
# 						options.success data
# 			jqXHR.fail (response) => console.log 'fail', response
# 		else
# 			super

# module.exports = Text