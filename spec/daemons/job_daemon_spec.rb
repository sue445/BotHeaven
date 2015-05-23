require 'rails_helper'

describe JobDaemon do
  before :each do
    JobDaemon.clear
  end

  describe '.enqueue' do
    subject do
      JobDaemon.enqueue(job)
    end

    let :job do
      JobDaemons::JobBase.new
    end

    it 'Enqueue Job' do
      expect {
        subject
      }.to change {
        JobDaemon.queued?
      }.from(false).to(true)
    end

    context 'When pass a instance of not inherited JobBase.' do
      let :job do
        Hash.new
      end

      it 'Raise Error.' do
        expect {
          subject
        }.to raise_error
      end
    end
  end

  describe '.dequeue' do
    subject do
      JobDaemon.dequeue
    end

    before :each do
      JobDaemon.enqueue job
    end

    let :job do
      JobDaemons::JobBase.new
    end

    it 'Return Job' do
      expect(subject).to eq(job)
    end

    it 'Deqeueue Job' do
      expect {
        subject
      }.to change {
        JobDaemon.queued?
      }.from(true).to(false)
    end
  end
end
