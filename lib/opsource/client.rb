module Opsource
  class Client
    include Opsource::Connection
    include Opsource::Params
    include Opsource::XML

    attr_reader :api_base, :org_id, :username, :password
    attr_reader :image, :directory, :network, :server

    ### FILTERS
    # client.page_size = 10
    # client.page_number = 1
    # client.order_by = 'location,created.DESCENDING'
    # client.filter_with = {location: %w(NA1 NA2), key: 'value'}
    attr_accessor :page_size, :page_number, :order_by, :filter_with



    def initialize(api_base, org_id, username, password, colors = true, silent = false)
      @api_base = api_base
      @org_id       = org_id
      @username     = username
      @password     = password

      @colors = colors
      @silent = silent

      if @colors
        require 'colorize'
      end
    end

    def directory
      Opsource::API::Directory.new(self)
    end

    def image
      Opsource::API::Image.new(self)
    end

    def network
      Opsource::API::Network.new(self)
    end

    def server
      Opsource::API::Server.new(self)
    end

    def filter_params
      params = {}
      params[:page_size] = @page_size if @page_size.present?
      params[:page_number] = @page_number if @page_number.present?
      params[:order_by] = @order_by if @order_by.present?

      if @filter_with.present?
        @filter_with.each do |k, val|
          params[k.to_sym] = val
        end
      end
      params
    end

    # mode: bold, underscore, default
    def log(message, color = nil, mode = nil)
      return if @silent
      if @colors
        color = color.to_sym if color
        mode = mode.to_sym if mode
        puts message.colorize(:color => color, :mode => mode)
      else
        puts message
      end
    end
  end
end