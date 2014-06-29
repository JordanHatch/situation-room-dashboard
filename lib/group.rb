module SituationRoom
  class Group

    attr_accessor :id, :name, :rooms

    def initialize(atts)
      @id = atts[:id]
      @name = atts[:name]
      @rooms = atts[:rooms]
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
      @@groups ||= SituationRoom.dashboard_config.dashboards
    end

  end
end
