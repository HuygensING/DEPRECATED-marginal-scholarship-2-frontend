Backbone = require 'backbone'
_ = require 'underscore'

tpl = require './index.jade'

class Locality extends Backbone.View

	className: 'locality'

	# ### Initialize
	initialize: (@options) ->
		@render()

	# ### Render
	render: ->
		data = @options.config.data
		
		@$el.html tpl
			regions: data.regions
			places: data.places
			scriptoria: data.scriptoria

		@

	events: ->
		"change li.regions select": "_handleRegionsChange"
		"change li.places select": "_handlePlacesChange"
		"change li.scriptoria select": "_handleScriptoriaChange"

	_handleRegionsChange: (ev) ->
		select = @$(ev.currentTarget)
		selectedValue = select.val()

		for region in @options.config.data.data
			if region.name is selectedValue
				options = @_createOptions region.places
				@$("li.places select").html options

				@triggerChange()

	_handlePlacesChange: (ev) ->
		select = @$(ev.currentTarget)
		selectedValue = select.val()

		for region in @options.config.data.data
			for place in region.places
				if place.name is selectedValue
					@_updateRegion region.name
					options = @_createOptions place.scriptoria
					@$("li.scriptoria select").html options

					@triggerChange()

	_handleScriptoriaChange: (ev) ->
		select = @$(ev.currentTarget)
		selectedValue = select.val()

		for region in @options.config.data.data
			for place in region.places
				for scriptorium in place.scriptoria
					if scriptorium.name is selectedValue
						@_updateRegion region.name
						@_updatePlace place.name

						@triggerChange()

	_updateRegion: (region) ->
		@$("li.regions select").val region

	_updatePlace: (place) ->
		@$("li.places select").val place

	###
	# Turn an array of string into HTML <option>s.
	#
	# @method
	# @param Array<String> values
	# @return DocumentFragment
	###
	_createOptions: (values) ->
		frag = document.createDocumentFragment()

		option = document.createElement "option"
		option.innerHTML = "&nbsp;"

		frag.appendChild option

		for val in values

			option = document.createElement "option"
			option.value = val.name
			option.innerHTML = val.name
			frag.appendChild option

		frag

	triggerChange: ->
		@trigger 'change',
			region: @$("li.regions select").val()
			place: @$("li.places select").val()
			scriptorium: @$("li.scriptoria select").val()

module.exports = Locality