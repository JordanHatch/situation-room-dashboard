module SituationRoom
  class RoomRepository

    class UndefinedRoom < StandardError; end

    def self.from_api_response(rooms)
      rooms.map {|id, room|
        begin
          build_room_from_response(id, room)
        rescue UndefinedRoom
          nil
        end
      }.compact
    end

    def self.from_single_api_response(id, room)
      build_room_from_response(id, room)
    end

  private

    def self.build_room_from_response(id, room)
      atts = { id: id }

      room_config = SituationRoom.dashboard_config.rooms[id]

      if room_config.blank?
        raise UndefinedRoom
      end

      atts.merge!(room).merge!(room_config).symbolize_keys!

      Room.new(atts)
    end
  end
end
