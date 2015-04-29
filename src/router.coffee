Backbone = require 'backbone'
$ = require 'jquery'
_ = require 'underscore'

Codex = require './views/codex'
EditCodex = require './views/codex/edit'

header = require './views/header'

pages =
	search: require './views/search'
	codices: {}
	editcodices: {}
	notFound: null

prevPage = null

show = (activePage, options) ->
	# showIt = ->
	prevPage = activePage
	activePage.activate(options) if activePage.activate?
	
	for pageId, pageInstance of pages

		if pageInstance?
			if pageInstance instanceof Backbone.View
				display = if pageInstance is activePage then 'block' else 'none'
				pageInstance.el.style.display = display
			else
				for id, pi of pageInstance
					display = if pi is activePage then 'block' else 'none'
					pi.el.style.display = display

###
# @class
# @namespace Routers
# @uses Search
###
class MainRouter extends Backbone.Router

	initialize: ->
		# Mimic a views $el var to use as the root el.
		@$el = $('body > .main')
		@$el.append pages.search.el

		@on 'route', (route, options) ->
			pagesClone = $.extend {}, pages, true
			delete pagesClone['notFound']

			header.renderTabs pagesClone, route, options

		@listenTo Backbone, "remove-codex-view", @_removeCodexView

	_removeCodexView: (id, redirectPath="") ->
		pages.codices[id].remove()
		delete pages.codices[id]
		
		if Backbone.history.getFragment() is ""
			pagesClone = $.extend {}, pages, true
			delete pagesClone['notFound']
			header.renderTabs pagesClone, "home"
		else
			@navigate redirectPath, trigger: true

	routes:
		'': 'home'
		'niet-gevonden': 'notFound'
		'codex/:id/edit/:sub': 'editcodex'
		'codex/:id/edit': 'editcodex'
		'codex/:id/:sub': 'codex'
		'codex/:id': 'codex'

	home: ->
		show pages.search

	editcodex: (id, sub) ->
		unless pages.editcodices.hasOwnProperty(id)
			pages.editcodices[id] = new EditCodex id: id, sub: sub
			$('body > .main > .editcodex').append pages.editcodices[id].el

		show pages.editcodices[id]

	codex: (id, sub) ->
		unless pages.codices.hasOwnProperty(id)
			pages.codices[id] = new Codex id: id, sub: sub
			$('body > .main > .codex').append pages.codices[id].el

		show pages.codices[id]

	notFound: ->
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
