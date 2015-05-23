require 'rails_helper'

RSpec.describe Bots::Apis::Storage do
  fixtures :bots
  fixtures :users
  fixtures :storages

  let :bot do
    Bot.find(1).tap do |bot|
      bot.update!(
        script: script,
      )
      bot.storage.update!(
        content: '{"hoge":"fuga","foo":"bar"}'
      )
    end
  end

  let :script do
    'function test() { return ""; }'
  end

  subject do
    bot.execute_function('test')
  end

  describe '#[]' do
    let :script do
      'function test() { return api.storage["hoge"]; }'
    end

    it 'Return hoge key value.' do
      expect(subject).to eq('fuga')
    end
  end

  describe '#[]=' do
    let :script do
      'function test() { return api.storage["hoge"]="piyo"; }'
    end

    it 'Set hoge key value.' do
      subject
      expect(bot.storage.content).to eq('{"hoge":"piyo","foo":"bar"}')
    end
  end

  describe '#keys' do
    let :script do
      'function test() { return api.storage.keys; }'
    end

    it 'Return keys' do
      expect(subject).to eq(['hoge', 'foo'].join(','))
    end
  end

  describe '#clear' do
    let :script do
      'function test() { return api.storage.clear(); }'
    end

    it 'clear storage' do
      subject
      expect(bot.storage.content).to eq('{}')
    end

    it 'Return true' do
      expect(subject).to eq(true.to_s)
    end
  end
end
