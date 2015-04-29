PersonForm = require './person'

module.exports =
	addPerson: (collection) ->
		personForm = new PersonForm()

		# When the modal is submitted, the text is saved to server and triggers a 'saved' event
		personForm.once 'saved', (personModel) =>
			collection.add
				id: personModel.id
				title: personModel.get 'name'

			@render()

	editPerson: (ev) ->
		# The event is triggered in a MultiForm, so we have to find the model we clicked first.
		modelID = @$(ev.currentTarget).parents('.model').attr 'data-cid'
		model = @collection.get modelID

		# The model holds the personID.
		personID = model.get('person').id

		# Instantiate the text form (loaded in a modal)
		personForm = new PersonForm value: _id: personID

		# When the modal is submitted, the text is saved to server and triggers a 'saved' event
		personForm.once 'saved', (personModel) =>
			# console.log 'edit save'
			# Update the @data.persons collection with the new person 
			personSimple = @data.persons.get personID
			personSimple.set 'title', personModel.get 'name'

			@render()