Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

mainRouter = require './router'

header = require './views/header'

$ ->
	Backbone.history.start pushState: true

	window.addEventListener 'scroll', (ev) ->
		console.log window.scrollY

	$('body > header').html header.el

	$(document).on 'click', 'a:not([data-bypass])', (e) ->
		href = $(@).attr 'href'
		
		if href?
			e.preventDefault()

			Backbone.history.navigate href, 'trigger': true