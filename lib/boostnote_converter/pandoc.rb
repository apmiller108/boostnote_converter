# frozen_string_literal: true

require 'English'
require 'tempfile'

module BoostnoteConverter
  class Pandoc
    CMD = 'pandoc -f gfm -t org %<path>s'

    def self.convert(cson)
      new(cson).convert
    end

    attr_reader :cson

    def initialize(cson)
      @cson = cson
    end

    def convert
      Tempfile.create(cson.name) do |file|
        file.write(cson.content)
        file.rewind
        result = `#{CMD % { path: file.path }}`
        raise ContentConversionFailedError unless $CHILD_STATUS.success?

        result
      end
    end
  end
end
