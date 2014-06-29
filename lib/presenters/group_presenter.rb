module SituationRoom
  class GroupPresenter
    def initialize(group)
      @group = group
    end

    def present(all_rooms)
      {
        name: @group.name,
        rooms: rooms_for_group(all_rooms)
      }
    end

    private
    def rooms_for_group(all_rooms)
      rooms = all_rooms.select {|room|
        @group.rooms.include?(room.id)
      }
      Hash[rooms.map {|room|
        [room.id, RoomPresenter.new(room).present]
      }]
    end
  end
end
