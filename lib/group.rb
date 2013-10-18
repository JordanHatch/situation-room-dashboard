module SituationRoom
  class Group

    attr_accessor :id, :name, :display, :calendars

    def initialize(atts)
      @id = atts[:id]
      @name = atts[:name]
      @display = atts[:display]
      @calendars = atts[:calendars]
      @show_all = atts[:show_all] || false
    end

    def self.all
      self.groups.map {|id,g|
        Group.new(g.symbolize_keys.merge(id: id))
      }
    end

    def self.find(id)
      self.all.find {|g| g.id == id }
    end

    def show_all?
      @show_all
    end

    private
    def self.groups
      @@groups ||= self.parse_config
    end

    def self.parse_config
      JSON.parse(user_config_or_fallback)["groups"]
    end

    def self.user_config_or_fallback
      ENV["SITUATION_ROOM_CONFIG"] || self.fallback_config
    end

    def self.fallback_config
      {
        "groups" => {
          "all" => {
            "name" => "All meeting rooms",
            "show_all" => true
          }
        }
      }.to_json
    end

  end
end
