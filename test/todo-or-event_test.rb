require 'test_helper'

class TodoOrEventTest < Test::Unit::TestCase
	# Simple, definitive phrases.
	def test_simple_language
		assert TodoOrEvent.is_todo?("RubyConf in June")
		assert not TodoOrEvent.is_todo?("Finish the advanced natural language parsing engine")
	end

	# Testing if the first two words are verbs.
	#
	# If they are, it is assumed that the first word is actually a dual
	# meaning word, where one definition is for a verb and another not.
	# (in this test, 'monkey' can be both a noun or a verb)
	def test_double_verb
		assert not TodoOrEvent.is_todo?("Monkey attack on the animal research center")
	end

	# This is where the aforementioned assumption falls apart. I'm not even
	# sure is valid english or not; but it is a testable case. Anyways, it's
	# supposed to be an action (todo) but instead is parsed as an event, as
	# both the first and second words are verbs.
	#
	# The second test not only sounds better to me, but is also properly
	# parsed, and is the recommended syntax.
	#
	# Any Zelda fans should recognize the claw shot mentioned here. I was
	# playing the water dungeon in Twilight Princess and thought it would
	# be funny to try to 'fish' the skullfish in using the claw shot.
	# Unfortunately, doesn't work.
	def test_verb_noun
		assert not TodoOrEvent.is_todo?("Catch fish with the claw shot")
		assert TodoOrEvent.is_todo? "Catch some fish with the claw shot"
	end
end
