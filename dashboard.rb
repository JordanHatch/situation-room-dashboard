$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'sinatra/base'
require 'active_support/all'

require 'api_client'
require 'dashboard_config'
require 'group'
require 'room'

require 'repositories/room_repository'

require 'presenters/group_presenter'
require 'presenters/room_presenter'

require 'decorators/event_decorator'
require 'decorators/room_decorator'

module SituationRoom
  mattr_accessor :dashboard_config

  class Dashboard < Sinatra::Base

    configure do
      set :api_endpoint, ENV["SITUATION_ROOM_API_ENDPOINT"]
      set :api_user, ENV["SITUATION_ROOM_API_USER"]
      set :api_password, ENV["SITUATION_ROOM_API_PASSWORD"]

      set :app_user, ENV['SITUATION_ROOM_DASHBOARD_USER']
      set :app_password, ENV['SITUATION_ROOM_DASHBOARD_PASSWORD']

      SituationRoom.dashboard_config = DashboardConfig.load_from_remote(ENV['SITUATION_ROOM_CONFIG_URI'])

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
      @rooms = situation_room_api.rooms.map {|name, room|
        RoomDecorator.new(name, room)
      }
      @available_rooms = @rooms.select {|r| r.available == true }
      @unavailable_rooms = @rooms.select {|r| r.available == false }

      erb :index
    end

    get '/api/rooms/:id' do
      begin
        response = situation_room_api.room(params[:id])
        @room = RoomRepository.from_single_api_response(params[:id], response)
      rescue RestClient::ResourceNotFound, RoomRepository::UndefinedRoom => e
        halt 404
      end

      content_type :json
      RoomPresenter.new(@room).present.to_json
    end

    get '/api/dashboards/:id' do
      @rooms = RoomRepository.from_api_response(situation_room_api.rooms)
      @group = Group.find(params[:id])

      content_type :json
      GroupPresenter.new(@group).present(@rooms).to_json
    end

    get '/dashboards/rooms/:id' do
      @room_id = params[:id]
      erb :'dashboards/room', layout: :'dashboards/layout'
    end

    get '/dashboards' do
      @groups = Group.all
      erb :'dashboards/index', layout: :'dashboards/layout'
    end

    get '/dashboards/:id' do
      @group = Group.find(params[:id])
      not_found unless @group.present?

      erb :'dashboards/show', layout: :'dashboards/layout'
    end

    # Redirect for old dashboard route
    get '/group/:id' do
      redirect "/dashboards/#{params[:id]}"
    end
  end
end
