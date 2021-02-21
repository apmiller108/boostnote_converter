require 'date'

class CSON
  attr_reader :contents

  PATTERNS = {
    created_at: 'createdAt:\s\"(?<created_at>.+)\"\n',
    updated_at: 'updatedAt:\s\"(?<updated_at>.+)\"\n'
  }.freeze

  def initialize(file)
    @contents = file.read
  end

  def created_at
    DateTime.parse(document_map[:created_at])
  end

  def updated_at
    DateTime.parse(document_map[:updated_at])
  end

  private

  def document_map
    @document_map = PATTERNS.each_with_object({}) do |(key, pattern), hash|
      hash[key] = contents.match(pattern)[key]
    end
  end
end
