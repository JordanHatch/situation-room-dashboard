require 'rest_client'
require 'json'

module SituationRoom
  class DashboardConfig
    def initialize
      @config = {}
    end

    def self.load_from_remote(url)
      instance = new
      instance.import(url)
      
      instance
    end

    def import(url)
      response = fetch_remote_config(url)
      @config = JSON.parse(response)
    rescue RestClient::Exception => e
      raise "Unable to request configuration from #{url}: #{e.message}"
    end

    def rooms
      @config['rooms'] || {}
    end

    def dashboards
      @config['dashboards'] || {}
    end

  private

    def fetch_remote_config(url)
      response = RestClient::Request.execute(
        method: :get,
        url: url
      )
    end
  end
end
