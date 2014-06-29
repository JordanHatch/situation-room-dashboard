class RoomDecorator
  attr_reader :name

  def initialize(name, room)
    @name = name
    @room = room
  end

  def available
    @room['available']
  end

  def next_available
    if @room.has_key?('next_available')
      Time.parse(@room['next_available']).localtime.strftime('%H:%M')
    end
  end

  def available_until
    if @room.has_key?('available_until')
      Time.parse(@room['available_until']).localtime.strftime('%H:%M')
    end
  end

  def events
    @room['events'].take(2).map {|event|
      EventDecorator.new(event)
    }
  end

end
