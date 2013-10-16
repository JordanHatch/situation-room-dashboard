$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'rubygems'
require 'sinatra/base'
require 'active_support/all'

require 'api_client'
require 'group'
require 'presenters/group_presenter'

module SituationRoom
  class Dashboard < Sinatra::Base

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

    get '/group/:id' do
      @group = params[:id]
      erb :dashboard
    end

    def situation_room_api
      @client ||= ApiClient.new(ENV["SITUATION_ROOM_API_ENDPOINT"], user: ENV["SITUATION_ROOM_API_USER"], password: ENV["SITUATION_ROOM_API_PASSWORD"])
    end
  end
end
