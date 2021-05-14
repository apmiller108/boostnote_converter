# frozen_string_literal: true

module BoostnoteConverter
  class OrgNoteExportOptions
    DATE_FORMAT = '%Y-%m-%d %H:%M %p'

    attr_reader :cson

    def initialize(cson)
      @cson = cson
    end

    def export_options
      format(<<~EXPORT_OPTIONS, options)
        #+title: %<title>s
        #+date: %<created_at>s
        #+updated: %<updated_at>s
        #+roam_tags: %<tags>s
      EXPORT_OPTIONS
    end

    private

    def options
      {
        title: title,
        created_at: created_at,
        updated_at: updated_at,
        tags: tags
      }
    end

    def title
      cson.title
    end

    def created_at
      cson.created_at.strftime(DATE_FORMAT)
    end

    def updated_at
      cson.updated_at.strftime(DATE_FORMAT)
    end

    def tags
      [*cson.tags, folder].join(' ')
    end

    def folder
      cson.folder.downcase.gsub(' ', '-')
    end
  end
end
