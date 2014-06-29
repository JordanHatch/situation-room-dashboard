module SituationRoom
  class RoomRepository
    def self.from_api_response(rooms)
      rooms.map {|id, room|
        atts = {
          id: id
        }

        atts.merge!(room)
        atts.merge!(SituationRoom.dashboard_config.rooms[id])

        Room.new(atts.symbolize_keys)
      }
    end
  end
end
