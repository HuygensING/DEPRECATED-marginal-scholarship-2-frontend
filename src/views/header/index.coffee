Backbone = require 'backbone'
LoginComponent = require 'hibb-login'

tpl = require './index.jade'
loginTpl = require './login.jade'

Tabs = require './tabs'

###
# @class Header
# @namespace Views
###
class Header extends Backbone.View
	###
	# @method
	# @construct
	# @param {Object} this.options
	###
	initialize: (@options) ->
		@render()
	
	###
	# @method
	###
	render: ->
		@$el.html tpl()

		@renderLoginButton()

		@

	renderLoginButton: ->
		@$(".login").html loginTpl
			user: LoginComponent.getUser()

	renderTabs: (pages, route, options) ->
		@tabs.remove() if @tabs?

		@tabs = new Tabs
			pages: pages
			route: route
			options: options
		@$('.tabs').html @tabs.el

	events: ->
		"click button": "_handleLogin"

	###
	# @method
	###
	_handleLogin: do ->
		loginView = null

		->
			loginView.destroy() if loginView?
	
			loginView = LoginComponent.getLoginView
				modal: true
				title: 'Inloggen'
				success: =>
					@render()

			# @listenTo loginView, 'modal:cancel', @_goBack
			# @listenTo loginView, 'request-access-complete', @_goBack

	# 	if LoginComponent.getUser().isLoggedIn()
	# 		LoginComponent.getLoginView().destroy()
	# 		@render()
	# 	else

module.exports = new Header()