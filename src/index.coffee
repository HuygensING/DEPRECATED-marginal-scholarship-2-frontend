Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

mainRouter = require './router'

header = require './views/header'

$ ->
	Backbone.history.start pushState: true

	window.addEventListener 'scroll', (ev) ->
		if window.scrollY > 100
			document.body.classList.add 'small-header'
		else
			document.body.classList.remove 'small-header'

	$('body > header').html header.el

	$(document).on 'click', 'a:not([data-bypass])', (e) ->
		href = $(@).attr 'href'
		
		if href?
			e.preventDefault()

			Backbone.history.navigate href, 'trigger': true