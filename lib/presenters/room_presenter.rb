module SituationRoom
  class RoomPresenter
    def initialize(room)
      @room = room
    end

    def present
      {
        name: @room.name,
        short_name: @room.short_name,
        events: @room.events,
        available: @room.available,
        next_available: @room.next_available,
        available_until: @room.available_until
      }
    end
  end
end
