class AlarmDaemon
  # Initialize Daemon.
  def initialize(interval: 1.minutes)
    @interval = interval
  end

  # Start RTM Client.
  def start
    EM.add_periodic_timer(30) do
      begin
        Alarm.check!
      rescue => e
        Rails.logger.error e.inspect
      end
    end
  end
end
