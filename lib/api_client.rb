require 'rest_client'
require 'json'

module SituationRoom
  class ApiClient
    def initialize(endpoint, options)
      @endpoint = endpoint
      @options = options
    end

    def rooms
      get_json("/rooms")["rooms"]
    end

    def room(room_number)
      get_json("/rooms/#{room_number}")
    end

    private

    def get_json(path)
      response = RestClient::Request.execute({
        method: :get,
        url: @endpoint + path
      }.merge(@options))

      JSON.parse(response)
    end
  end
end
