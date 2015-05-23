require 'rails_helper'

describe JobDaemons::SlackTalkJob do
  fixtures :bots
  fixtures :users

  let :job do
    JobDaemons::SlackTalkJob.new('test', 'test', 'test', 'test')
  end

  describe '#execute!' do
    subject do
      job.execute!
    end

    it 'Call #execute_function of bot' do
      expect(SlackUtils::SingletonClient.instance).to receive(:send_message).once
      subject
    end
  end
end
