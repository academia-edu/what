module What
  module Helpers
    # Take an array of healths and determine overall health, on
    # the principle that overall health == the worst sub-health.
    HEALTH = %w(ok warning alert)
    def self.overall_health(healths)
      worst_health = healths.map do |health|
        HEALTH.index(health) || HEALTH.index('alert')
      end.max

      # No news is null news.
      if worst_health
        HEALTH[worst_health]
      end
    end

    # Stolen from Rails (http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html)
    def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        lower_case_and_underscored_word.to_s[0].chr.downcase + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end

    def self.underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def self.curl(uri)
      yield(Excon.get(uri).body)
    end
  end
end
