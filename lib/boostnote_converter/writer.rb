# frozen_string_literal: true

module BoostnoteConverter
  class Writer
    attr_reader :document, :output_path

    def initialize(document, output_path)
      @document = document
      @output_path = output_path
    end

    def write
      File.write(filename, document.read)
    end

    private

    def filename
      "#{Pathname.new(output_path).realpath}/#{document.filename}"
    end
  end
end
