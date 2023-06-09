# frozen_string_literal: true

module Texter
  class Stopwords
    #
    # class methods
    #
    def self.dictionary
      Dir.glob(File.join(__dir__, 'locales', '*.csv')).each_with_object({}) do |file, memo|
        locale = file.split('/').last.split('.').first
        memo[locale] = File.read(file).split(',')
      end
    end

    #
    # instance methods
    #
    attr_accessor :stopwords
    attr_reader :lang, :text

    # Public: initialize it
    # lang - a String, the ISO code of a language is required
    # list - an Array of Strings, replacing the default local list of words
    def initialize(lang:, text: '', list: [])
      raise Texter::Error, 'missing lang' if lang.blank?

      @lang = lang
      @text = text
      @stopwords = list.empty? ? self.class.dictionary[lang] : list.map(&:downcase)
    end

    def filtered
      return text unless stopwords

      @filtered ||= splitted.reject { |w| stopwords.include?(w.downcase) }.join(' ')
    end

    def splitted
      @splitted ||= @text.split.map { |w| w.gsub(/[[:punct:]]$/, '').gsub(/[\[\]{}()]*/, '') }
    end
  end
end
