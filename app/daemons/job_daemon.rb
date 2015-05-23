class JobDaemon
  # Queues
  @@queues = Queue.new

  # Mutex
  @@mutex = Mutex.new

  # Start Daemon.
  def start
    EM.add_periodic_timer(0.5) do
      begin
        @@mutex.synchronize { execute_job }
      rescue => e
        Rails.logger.error(e)
        e.backtrace.each {|l| Rails.logger.error(l)}
      end
    end
  end

  # Enqueue job.
  # @param [JobDaemons::JobBase] job Job.
  def self.enqueue(job)
    raise 'Job should be inherited class of JobDaemons::JobBase' unless job.kind_of?(JobDaemons::JobBase)
    @@queues.enq job
  end

  # Dequeue job.
  # @return [JobDaemons::JobBase] Job.
  def self.dequeue
    @@queues.deq
  end

  # Check if queued job.
  # @return [Boolean] true if job exist.
  def self.queued?
    !@@queues.empty?
  end

  # Clear Jobs.
  def self.clear
    @@queues.clear
  end

  private
  # Execute Job.
  def execute_job
    while JobDaemon.queued?
      begin
        JobDaemon.dequeue.execute!
      rescue => e
        Rails.logger.error(e)
        e.backtrace.each {|l| Rails.logger.error(l)}
      end
    end
  end
end
