# frozen_string_literal: true

module Api
  class Error
    attr_accessor :title, :detail, :id, :href, :code, :source, :links, :status, :meta

    def initialize(options = {})
      @title          = options[:title]
      @detail         = options[:detail]
      @id             = options[:id]
      @href           = options[:href]
      @code           = options[:code]
      @source         = options[:source]
      @links          = options[:links]

      @status         = Rack::Utils::SYMBOL_TO_STATUS_CODE[options[:status]].to_s
      @meta           = options[:meta]
    end

    def as_json(_options = {})
      { title: title, detail: detail, id: id, href: href, code: code, source: source, links: links, status: status, meta: meta }
    end
  end
end
