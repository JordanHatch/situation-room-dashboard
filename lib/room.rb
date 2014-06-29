module SituationRoom
  class Room
    attr_accessor :id, :name, :short_name, :events, :available,
                    :next_available, :available_until

    def initialize(atts)
      @id = atts[:id]
      @name = atts[:name]
      @short_name = atts[:short_name]
      @events = atts[:events]
      @available = atts[:available]
      @next_available = atts[:next_available]
      @available_until = atts[:available_until]
    end
  end
end
