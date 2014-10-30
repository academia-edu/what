module What
  module Helpers
    # Take an array of healths and determine overall health, on
    # the principle that overall health == the worst sub-health.
    HEALTH = %w(ok warning alert)
    def self.overall_health(healths)
      worst_health(healths)
    end

    def self.worst_health(healths)
      ordered_healths(healths).last
    end

    def self.best_health(healths)
      ordered_healths(healths).first
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
      yield(open(uri).read)
    end

    # Performs a simple strip of invalid UTF-8 characters on the output of 'ps aux'
    def self.process_lines
      `ps aux`.encode('UTF-16', invalid: :replace, undef: :replace).encode('UTF-8').split("\n")
    end

    private

    def self.ordered_healths(healths)
      healths.sort_by do |health|
        HEALTH.index(health) || HEALTH.index('alert')
      end
    end

  end
end
