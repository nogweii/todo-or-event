# See README for more documentation.
#
# Copyright (C) Colin Shea
# Released under the Ruby License, 2009. See LICENSE.txt
class TodoOrEvent
	# In case WNHOME isn't exported or wordnet isn't installed in /usr/share/wordnet, modify this path
	# to point to the correct location.
	attr_writer :path

	@path = ENV['WNHOME'] || "/usr/share/wordnet"
	@words = []

	class << self
		# Load the verbs into an array as regular expressions unless it's done so already.
		#
		# Meant for internal use.
		#
		# @return [Array] A series of regular expressions matching /^(verb)\s(.*)/
		def words
			if @words.empty?
				File.readlines(File.join(@path, 'dict', 'index.verb')).each do |line|
					@words << Regexp.new("^(#{line.split(' ').first.gsub(/_/, ' ').downcase})\s(.*)") unless line =~ /^\s/
				end
			end
			@words
		end

		# Looping through the regular expressions in @words, determines
		# if the data begins with a verb.
		#
		# Meant for internal use.
		#
		# @param [String] comparison_data String to check for verbs
		# @return [MatchData] The results of the regular expression.
		def match_verbs(comparison_data)
			normalized = comparison_data.downcase.sub(/^go\s/, '')
			words.each do |verb_rx|
				if match_data = normalized.match(verb_rx)
					return match_data
				end
			end
			return false
		end

		# Attempts to determine if a string is a todo or an event by
		# checking if the first word is a verb. If it is not a verb,
		# fall back to being an event description.
		#
		# @param [String] line The line to parse
		# @raise [ArgumentError] When line is nil. line must be a string
		# @return [Symbol] :todo if line is a todo, :event if it's an
		#   event. nil if line is empty.
		# @example Determine if the user input is a todo
		#   TodoOrEvent.parse("Finish this library") #=> :todo
		def parse(line)
			raise ArgumentError, "Can't parse nil" if line.nil?
			return nil if line.empty?

			if match_data = match_verbs(line)
				if mdata2 = match_verbs(match_data[2])
					return :event
				else
					return :todo
				end
			end
			return :event
		end
	end
end
