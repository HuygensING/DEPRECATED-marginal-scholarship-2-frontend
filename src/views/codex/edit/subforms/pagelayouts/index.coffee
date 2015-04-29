$ = require 'jquery'
_ = require "underscore"

$.fn.appendCloseButton = (args={}) ->
	{corner, html, close} = args

	html ?= '<img src="/images/icon.close.png">'
	corner ?= 'topright'

	$closeButton = $('<div class="closebutton">').html html

	$closeButton.css 'position', 'absolute'
	$closeButton.css 'opacity', '0.2'
	$closeButton.css 'cursor', 'pointer'
	
	switch corner
		when 'topright'
			$closeButton.css 'right', '8px'
			$closeButton.css 'top', '8px'
		when 'bottomright'
			$closeButton.css 'right', '8px'
			$closeButton.css 'bottom', '8px'

	@prepend $closeButton

	$closeButton.hover ((ev) -> $closeButton.css 'opacity', 100), ((ev) -> $closeButton.css 'opacity', 0.2)
	$closeButton.click => close()


Model = require './model'

MultiForm = require '../../form/multi'

Tpl = require "./index.jade"

calcAspectRatio = (originalWidth, originalHeight, boxWidth, boxHeight) ->
	widthRatio = boxWidth / originalWidth
	heightRatio = boxHeight / originalHeight

	Math.min widthRatio, heightRatio

class PageLayouts extends MultiForm

	className: 'pagelayouts form'

	initialize: ->
		@tpl = Tpl
		@Model = Model

		super

	postRender: -> 
		@collection.each (model) =>	@dimensionChanged model.cid
		@calcOldLayoutRatio()

		$layoutinfo = @$ '#layoutinfo'
		$layoutinfo.appendCloseButton
			html: '<img src="/static/form/images/icon.close.png">'
			close: => $layoutinfo.hide()

	events: -> _.extend super, 
		evs = 
			'keyup input[name="textWidthMin"]': 'calcOldLayoutRatio'
			'keyup input[name="textWidthMax"]': 'calcOldLayoutRatio'
			'keyup input[name="textHeightMin"]': 'calcOldLayoutRatio'
			'keyup input[name="textHeightMax"]': 'calcOldLayoutRatio'

		evs['keyup input[name="horizontalLayout"]'] = 'dimensionChanged'
		evs['keyup input[name="verticalLayout"]'] = 'dimensionChanged'
		evs['click button.layoutinfo'] = 'toggleLayoutInfo'

		evs

	toggleLayoutInfo: (ev) ->
		$target = $ ev.currentTarget
		targetPosition = $target.offset()
		
		$layoutinfo = @$ '#layoutinfo'

		newLeft = targetPosition.left + 40
		newTop = targetPosition.top - $layoutinfo.height()/2

		newPos = false

		if $layoutinfo.offset().top isnt newTop
			$layoutinfo.css 'left', newLeft
			$layoutinfo.css 'top', newTop
			newPos = true

		if $layoutinfo.is(':hidden') or newPos
			$layoutinfo.fadeIn('fast')
		else
			$layoutinfo.hide()

	calcOldLayoutRatio: (ev) ->
		return false unless document.querySelector('input[name="bookDimensions.width"]')? and @el.querySelector('input[name="textWidthMin"]')?

		pageWidth = +document.querySelector('input[name="bookDimensions.width"]').value ? 0
		pageHeight = +document.querySelector('input[name="bookDimensions.height"]').value

		minWidth = +@el.querySelector('input[name="textWidthMin"]').value
		minHeight = +@el.querySelector('input[name="textHeightMin"]').value

		maxWidth = +@el.querySelector('input[name="textWidthMax"]').value
		maxHeight = +@el.querySelector('input[name="textHeightMax"]').value

		minRatio = (minWidth * minHeight) / (pageWidth * pageHeight) * 100
		maxRatio = (maxWidth * maxHeight) / (pageWidth * pageHeight) * 100

		text = if _.isFinite(minRatio) and _.isFinite(maxRatio) then Math.round(minRatio) + '% - ' + Math.round(maxRatio) + '%' else ''

		@el.querySelector('span.generallayoutratio').innerHTML = text


	dimensionChanged: (ev) ->
		cid = if ev.hasOwnProperty 'target' then $(ev.currentTarget).parents('li.model').attr 'data-cid' else ev

		horizontalLayout = @el.querySelector('li.model[data-cid="'+cid+'"] input[name="horizontalLayout"]').value
		horizontalLayout = horizontalLayout.split(/<|>/).map (val) -> parseInt val, 10

		verticalLayout = @el.querySelector('li.model[data-cid="'+cid+'"] input[name="verticalLayout"]').value
		verticalLayout = verticalLayout.split(/<|>/).map (val) -> parseInt val, 10

		filledColumnWidths = []
		emptyColumnWidths = []

		filledBlockHeights = []
		emptyBlockHeights = []

		for width, i in horizontalLayout
			if i % 2 is 0
				emptyColumnWidths.push parseInt width, 10
			else
				filledColumnWidths.push parseInt width, 10

		for height, i in verticalLayout
			if i % 2 is 0
				emptyBlockHeights.push parseInt height, 10
			else
				filledBlockHeights.push parseInt height, 10
		
		filledHor = filledColumnWidths.reduce (p, c) -> p + c
		filledVer = filledBlockHeights.reduce (p, c) -> p + c

		totalWidth = horizontalLayout.reduce (p, c) -> p + c
		totalHeight = verticalLayout.reduce (p, c) -> p + c

		totalArea = totalWidth * totalHeight
		filledArea = filledHor * filledVer

		space = Math.round 100-(filledArea/totalArea*100)

		spaceText = ''

		if _.isFinite(space)
			spaceText = "Space for marginalia: #{space}%"
			@drawLayout cid, horizontalLayout, verticalLayout

		@$('li.model[data-cid="'+cid+'"] span.space').html spaceText
		
	drawLayout: (cid, hor, ver) ->
		canvas = @el.querySelector('li.model[data-cid="'+cid+'"] canvas.layout')
		ctx = canvas.getContext '2d'

		totalWidth = hor.reduce (p, c) -> p + c
		totalHeight = ver.reduce (p, c) -> p + c

		aspectRatio = calcAspectRatio totalWidth, totalHeight, 150, 150


		canvasWidth = totalWidth*aspectRatio
		canvasHeight = totalHeight*aspectRatio

		canvas.width = canvasWidth
		canvas.height = canvasHeight

		ctx.clearRect 0, 0, canvasWidth, canvasHeight

		ctx.fillStyle = "rgb(200,200,200)"
		ctx.fillRect 0, 0, canvasWidth, canvasHeight

		# Draw horizontal areas
		filled = false
		left = 0
		hor.map (columnWidth) ->
			if filled
				ctx.fillStyle = "rgb(120,120,120)"
				ctx.fillRect left*aspectRatio, 0, columnWidth*aspectRatio, canvasHeight

			filled = !filled
			left += columnWidth

		# Draw vertical areas
		empty = true
		top = 0
		ver.map (rowHeight) ->
			if empty
				ctx.fillStyle = "rgb(200,200,200)"
				ctx.fillRect 0, top*aspectRatio, canvasWidth, rowHeight*aspectRatio

			empty = !empty
			top += rowHeight

module.exports = PageLayouts