require 'rest_client'

class MonitorNotifier
  def self.notify(room_id)
    new(room_id).notify
  end

  def initialize(room_id)
    @room_id = room_id
  end

  def notify
    # don't try and notify if we haven't got an api key set up for this instance
    return unless api_key.present?

    RestClient.post(endpoint, request_params)
  rescue RestClient::Exception
    false
  end

private
  attr_reader :room_id

  def request_params
    {
      api_key: api_key,
    }
  end

  def endpoint
    "#{ENV['MONITOR_ENDPOINT']}rooms/#{room_id}"
  end

  def api_key
    ENV['NOTIFIER_API_KEY']
  end
end
