require 'rails_helper'

describe JobDaemons::BotJob do
  fixtures :bots
  fixtures :users

  let :job do
    JobDaemons::BotJob.new(Bot.find(1).id, 'method', ['params'])
  end

  describe '#execute!' do
    subject do
      job.execute!
    end

    it 'Call #execute_function of bot' do
      expect_any_instance_of(Bot).to receive(:execute_function).once
      subject
    end
  end
end
