Form = require "../../../../../models/form"

class PageLayout extends Form

	validation:
		# blockHeights:
		# 	pattern: 'number'
		# 	required: false
		# columnWidths:
		# 	pattern: 'number'
		# 	required: false
		foliaCount:
			pattern: 'number'
			required: false
		lineHeight:
			pattern: 'number'
			required: false
		linesMax:
			pattern: 'number'
			required: false
		linesMin:
			pattern: 'number'
			required: false
		# marginBottom:
		# 	pattern: 'number'
		# 	required: false
		# marginLeft:
		# 	pattern: 'number'
		# 	required: false
		# marginRight:
		# 	pattern: 'number'
		# 	required: false
		# marginTop:
		# 	pattern: 'number'
		# 	required: false
		pages:
			pattern: 'number'
			required: false
		textHeightMax:
			pattern: 'number'
			required: false
		textHeightMin:
			pattern: 'number'
			required: false
		textWidthMax:
			pattern: 'number'
			required: false
		textWidthMin:
			pattern: 'number'
			required: false

	defaults: ->
		blockHeights: []
		columnWidths: []
		foliaCount: ""
		lineHeight: ""
		linesMax: ""
		linesMin: ""
		marginBottom: ""
		marginLeft: ""
		marginRight: ""
		marginTop: ""
		pages: ""
		remarks: ""
		textHeightMax: ""
		textHeightMin: ""
		textWidthMax: ""
		textWidthMin: ""

	get: (attr) ->
		
		calcMiddle = (aray) =>
			# The blockHeights and columnWidths are simple arrays ([5, 10, 5, 15]), so 
			# we can clone/deepcopy them to lose the reference to the original with slice.
			arr = aray.slice 0

			left = false
			str = ''
			
			while last = arr.pop()
				sign = if left then '<' else '>'
				str = last + sign + str
				left = !left

			str

		if attr is 'horizontalLayout'
			cws = calcMiddle @get 'columnWidths'
			return @get('marginLeft') + '<' + cws + @get('marginRight')
		else if attr is 'verticalLayout'
			bh = calcMiddle @get 'blockHeights'
			return @get('marginTop') + '<' + bh + @get('marginBottom')
		else
			super

	set: (attrs, options) ->
		# [attrs, options] = @setter attrs, options, 'blockHeights', (val) ->
		# 	if _.isString(val) then [val] else val

		# [attrs, options] = @setter attrs, options, 'columnWidths', (val) ->
		# 	if _.isString(val) then [val] else val


		if attrs is 'horizontalLayout'
			indexLeft = options.indexOf('<')
			indexRight = options.lastIndexOf('>')

			if indexLeft > -1 and indexRight > -1
				@set 'marginLeft', options.substr(0, indexLeft), silent: true
				@set 'marginRight', options.substr(indexRight + 1), silent: true
				middle = options.substring indexLeft+1, indexRight
				@set 'columnWidths', middle.split(/<|>/), silent: true
				@trigger 'change', @

		else if attrs is 'verticalLayout'
			indexTop = options.indexOf('<')
			indexBottom = options.lastIndexOf('>')

			if indexTop > -1 and indexBottom > -1
				@set 'marginTop', options.substr(0, indexTop), silent: true
				@set 'marginBottom', options.substr(indexBottom + 1)
				middle = options.substring indexTop+1, indexBottom
				@set 'blockHeights', middle.split(/<|>/), silent: true
				@trigger 'change', @

		else
			super

module.exports = PageLayout