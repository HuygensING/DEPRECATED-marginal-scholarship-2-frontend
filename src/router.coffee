Backbone = require 'backbone'
_ = require 'lodash'
$ = require 'jquery'

Search = require './views/search'

pages =
	home: null
	notFound: null

prevPage = null

show = (activePage, options) ->
	# showIt = ->
	prevPage = activePage
	activePage.activate(options) if activePage.activate?
	
	for pageId, pageInstance of pages
		# DEBUG
		# console.log pageId, pageInstance, activePage, pageInstance is activePage
		if pageInstance?
			display = if pageInstance is activePage then 'block' else 'none'
			pageInstance.el.style.display = display

###
# @class
# @namespace Routers
# @uses Search
###
class MainRouter extends Backbone.Router

	initialize: ->
		# Mimic a views $el var to use as the root el.
		@$el = $('body > .main')

	routes:
		'': 'home'
		'niet-gevonden': 'notFound'

	"home": ->
		unless pages.home?
			pages.home = new Search()
			@$el.append pages.home.el

		show pages.home

	"notFound": ->
		unless pages.notFound?
			pages.notFound = new Backbone.View()
			pages.notFound.$el.html "<div class=\"not-found\">
				<i class=\"fa fa-chain-broken\" />
				De gevraagde pagina is niet gevonden, ga terug naar
				de <a href=\"\">zoekpagina</a>.

				</div>"
			@$el.append pages.notFound.el

		show pages.notFound

module.exports = new MainRouter()
