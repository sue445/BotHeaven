unless EM.reactor_running? && EM.reactor_thread.alive?
  Thread.new { EM.run }
  while !EM.reactor_running?
    sleep 1
  end
end
