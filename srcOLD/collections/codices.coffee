Backbone = require "backbone"

Codex = require "../models/codex"

class Codices extends Backbone.Collection
	model: Codex

module.exports = new Codices()

