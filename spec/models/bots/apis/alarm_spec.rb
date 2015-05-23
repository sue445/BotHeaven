require 'rails_helper'

RSpec.describe Bots::Apis::Alarm do
  fixtures :bots
  fixtures :users
  fixtures :alarms
  fixtures :storages

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

  describe '#regist' do
    let :script do
      'function test() { return api.alarm.regist("hoge", "callbackfunc", 1, false); }'
    end

    it 'Add alarm' do
      expect {
        subject
      }.to change(Alarm, :count).by(1)
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end

  describe '#remove' do
    let :script do
      'function test() { return api.alarm.remove("schedule"); }'
    end

    it 'Remove alarm' do
      expect {
        subject
      }.to change(Alarm, :count).by(-1)
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end

  describe '#all' do
    let :script do
      'function test() { return api.alarm.all; }'
    end

    it 'Return all alarm names.' do
      expect(subject).to eq(bot.alarms.map(&:name).join(','))
    end
  end

  describe '#clear' do
    let :script do
      'function test() { return api.alarm.clear(); }'
    end

    it 'Remove all alarms' do
      expect {
        subject
      }.to change(Alarm, :count).by(-bot.alarms.count)
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end
end
