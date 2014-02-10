$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'sinatra/base'
require 'active_support/all'

require 'api_client'
require 'group'

require 'presenters/group_presenter'
require 'presenters/room_presenter'

module SituationRoom
  class Dashboard < Sinatra::Base

    configure do
      set :api_endpoint, ENV["SITUATION_ROOM_API_ENDPOINT"]
      set :api_user, ENV["SITUATION_ROOM_API_USER"]
      set :api_password, ENV["SITUATION_ROOM_API_PASSWORD"]

      set :app_user, ENV['SITUATION_ROOM_DASHBOARD_USER']
      set :app_password, ENV['SITUATION_ROOM_DASHBOARD_PASSWORD']

      unless settings.api_endpoint.present?
        raise "No endpoint has been configured. Make sure the SITUATION_ROOM_API_ENDPOINT environment variable is present."
      end

      if settings.app_user? && settings.app_password?
        use Rack::Auth::Basic, "Please login to this dashboard" do |username, password|
          username == settings.app_user and password == settings.app_password
        end
      end
    end

    helpers do
      def situation_room_api(options = {})
        if settings.api_user? && settings.api_password?
          options.merge!(user: settings.api_user, password: settings.api_password)
        end

        @client ||= ApiClient.new(settings.api_endpoint, options)
      end
    end

    get '/' do
      @groups = Group.all
      erb :index
    end

    get '/api/group/:id' do
      @rooms = situation_room_api.rooms
      @group = Group.find(params[:id])

      content_type :json
      GroupPresenter.new(@group).present(@rooms).to_json
    end

    get '/api/rooms/:id' do
      begin
        @room = situation_room_api.room(params[:id])
      rescue RestClient::ResourceNotFound
        halt 404
      end

      content_type :json
      RoomPresenter.new(params[:id], @room).present.to_json
    end

    get '/group/:id' do
      @group = Group.find(params[:id])
      not_found unless @group.present?

      erb :dashboard
    end

    get '/rooms/:id' do
      @room_id = params[:id]

      erb :room
    end
  end
end

