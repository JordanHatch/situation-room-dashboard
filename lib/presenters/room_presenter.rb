module SituationRoom
  class RoomPresenter
    def initialize(room_number, room)
      @room_number = room_number
      @room = room
    end

    def present
      {
        room_number: @room_number,
        events: @room["events"],
        available: @room["available"],
        next_available: @room["next_available"],
        available_until: @room["available_until"]
      }
    end
  end
end
