require 'rubygems'
gem 'wordnet', '>=0.0.5'
require 'wordnet'

class TodoOrEvent
	@path = File.join(ENV['WNHOME'] || "/usr/share/wordnet", 'dict', 'index.verb')
	@words = []
	File.readlines(@path).each do |line|
		@words << Regexp.new("^(#{line.split(' ').first.gsub(/_/, ' ').downcase})\s(.*)") unless line =~ /^\s/
	end

	class << self
		def match_verbs(comparison_data)
			normalized = comparison_data.downcase.sub(/^go\s/, '')
			@words.each do |verb_rx|
				if match_data = normalized.match(verb_rx)
					#p "It matches #{verb_rx}"
					return match_data
				end
			end
			return false
		end

		def is_todo?(line)
			if match_data = match_verbs(line)
				#p "Begins with a verb", match_data
				if mdata2 = match_verbs(match_data[2])
					#p "Begins with a verb again", mdata2
					return false
				else
					return true
				end
			end
			return false
		end
	end
end
