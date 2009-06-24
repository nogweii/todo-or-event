class TodoOrEvent
	# In case WNHOME isn't exported or wordnet isn't installed in /usr/share/wordnet, modify this path
	# to point to the correct location.
	attr_writer :path

	@path = ENV['WNHOME'] || "/usr/share/wordnet"
	@words = []

	class << self
		# Load the verbs into an array as regular expressions unless it's done so already.
		#
		# @return [Array] A series of regular expressions matching /^verb\s/
		def words
			if @words.empty?
				File.readlines(File.join(@path, 'dict', 'index.verb')).each do |line|
					@words << Regexp.new("^(#{line.split(' ').first.gsub(/_/, ' ').downcase})\s(.*)") unless line =~ /^\s/
				end
			end
			@words
		end

		def match_verbs(comparison_data)
			normalized = comparison_data.downcase.sub(/^go\s/, '')
			words.each do |verb_rx|
				if match_data = normalized.match(verb_rx)
					return match_data
				end
			end
			return false
		end

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
