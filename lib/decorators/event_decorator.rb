class EventDecorator
  attr_reader :name

  def initialize(event)
    @event = event
  end

  def start_at
    Time.parse(@event['start_at']).localtime.strftime("%H:%M")
  end

  def end_at
    Time.parse(@event['end_at']).localtime.strftime("%H:%M")
  end

  def name
    if self.private?
      "Not available"
    else
      @event['name']
    end
  end

  def creator
    @event['creator']
  end

  def visibility
    @event['visibility']
  end

  def private?
    visibility == "private"
  end

end
