Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

config = require "./models/config"

LoginComponent = require 'hibb-login'

LoginComponent.init
	federated:
		url: "https://secure.huygens.knaw.nl/saml2/login"

LoginComponent.createUser
	tokenPrefix: 'marschol2'
	tokenType: "Federated "
	url: ->
		config.get("meUrl")
	# headers:
	# 	VRE_ID: config.VRE_ID

mainRouter = require './router'

data = require './models/data'
header = require './views/header'


$ ->
	data.fetch ->
		Backbone.history.start pushState: true

		LoginComponent.getUser().authorize()

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