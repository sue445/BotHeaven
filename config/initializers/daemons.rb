BotsHeaven::Application.config.after_initialize do
  if Rails.env.production?
    # Start SlackDaemon.
    SlackDaemon.new.start

    # Start Alarm
    AlarmDaemon.new.start

    # Start JobDaemon
    JobDaemon.new.start
  end
end
