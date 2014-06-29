module SituationRoom
  class GroupPresenter
    def initialize(group)
      @group = group
    end

    def present(rooms)
      {
        name: @group.name,
        rooms: rooms_for_group(rooms)
      }
    end

    private
    def rooms_for_group(rooms)
      rooms.select {|id,room| @group.rooms.include?(id) }
    end
  end
end
