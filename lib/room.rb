module SituationRoom
  class Room
    attr_accessor :id, :name, :short_name, :events, :available,
                    :next_available, :available_until, :show_as_available,
                    :not_available_label

    def initialize(atts)
      @id = atts[:id]
      @name = atts[:name]
      @short_name = atts[:short_name]
      @events = atts[:events]
      @available = atts[:available]
      @next_available = atts[:next_available]
      @available_until = atts[:available_until]
      @show_as_available = atts[:show_as_available]
      @not_available_label = atts[:not_available_label]
    end
  end
end
