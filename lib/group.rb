module SituationRoom
  class Group

    attr_accessor :id, :name, :display, :calendars

    def initialize(atts)
      @id = atts[:id]
      @name = atts[:name]
      @display = atts[:display]
      @calendars = atts[:calendars]
    end

    def self.all
      self.groups.map {|id,g|
        Group.new(g.symbolize_keys.merge(id: id))
      }
    end

    def self.find(id)
      self.all.find {|g| g.id == id }
    end

    private
    def self.groups
      @@groups ||= self.parse_config
    end

    def self.parse_config
      JSON.parse(request_calendars_config)["groups"]
    end

    def self.request_calendars_config
      ENV["SITUATION_ROOM_CONFIG"]
    end

  end
end
