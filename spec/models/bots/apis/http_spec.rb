require 'rails_helper'

RSpec.describe Bots::Apis::HTTP do
  fixtures :bots
  fixtures :users
  fixtures :alarms

  let :bot do
    Bot.find(1).tap do |bot|
      bot.update!(script: script)
    end
  end

  let :script do
    'function test() { return ""; }'
  end

  subject do
    bot.execute_function('test')
  end

  describe '#get' do
    let :script do
      'function test() { return api.http.get("http://www.google.co.jp/", {}, "cb");}; function cb(a){};'
    end

    it 'Enqueue Job.' do
      expect(JobDaemon).to receive(:enqueue).once
      subject
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end

  describe '#post' do
    let :script do
      'function test() { return api.http.post("http://www.google.co.jp/", {}, "cb");}; function cb(a){};'
    end

    it 'Enqueue Job.' do
      expect(JobDaemon).to receive(:enqueue).once
      subject
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end
end
