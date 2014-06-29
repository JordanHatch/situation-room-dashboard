module SituationRoom
  class RoomRepository
    def self.from_api_response(rooms)
      rooms.map {|id, room|
        build_room_from_response(id, room)
      }
    end

    def self.from_single_api_response(id, room)
      build_room_from_response(id, room)
    end

  private

    def self.build_room_from_response(id, room)
      atts = { id: id }

      atts.merge!(room)
      atts.merge!(SituationRoom.dashboard_config.rooms[id])

      Room.new(atts.symbolize_keys)
    end
  end
end
