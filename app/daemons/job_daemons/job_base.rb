module JobDaemons
  # JobBase of JobDaemon
  class JobBase
    # Execute job.
    # @abstract Need Override in child class.
    def execute!
      raise 'Called abstract method execute.'
    end
  end
end
