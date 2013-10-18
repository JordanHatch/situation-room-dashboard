module SituationRoom
  class GroupPresenter
    def initialize(group)
      @group = group
    end

    def present(rooms)
      {
        name: @group.name,
        display: @group.display,
        rooms: rooms_for_group(rooms)
      }
    end

    private
    def rooms_for_group(rooms)
      return rooms if @group.show_all?
      rooms.select {|id,room| @group.calendars.include?(id) }
    end
  end
end
