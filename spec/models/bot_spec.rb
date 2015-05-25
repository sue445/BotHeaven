require 'rails_helper'

RSpec.describe Bot, type: :model do
  fixtures :bots
  fixtures :bot_modules
  fixtures :bot_bot_modules
  fixtures :users

  let :bot do
    Bot.find(1).tap do |bot|
      bot.update(
          script: script,
      )
    end
  end

  let :script do
    'function onTalk(name, text) { return name + "-" + text }'
  end

  describe '#name' do
    it 'Presence' do
      expect(bot).to validate_presence_of(:name)
    end

    it 'Length Range in 1,32' do
      expect(bot).to validate_length_of(:name).is_at_least(1).is_at_most(32)
    end
  end

  describe '#channel' do
    it 'Presence' do
      expect(bot).to validate_presence_of(:channel)
    end

    it 'Length Range in 1,32' do
      expect(bot).to validate_length_of(:channel).is_at_least(1).is_at_most(32)
    end
  end

  describe '#user' do
    it 'Presence' do
      expect(bot).to validate_presence_of(:user)
    end
  end

  describe '#default_icon' do
    it 'Length Range in 0,32' do
      expect(bot).to validate_length_of(:default_icon).is_at_most(32)
    end
  end

  describe '#script' do
    it 'Presence' do
      expect(bot).to validate_presence_of(:script)
    end

    it 'Length Range in 1,64kb' do
      expect(bot).to validate_length_of(:script).is_at_least(1).is_at_most(64.kilobytes)
    end
  end

  describe '#channel_id' do
    subject do
      bot.channel_id
    end

    context 'when empty' do
      before :each do
        bot.update_column(:channel_id, nil)
      end

      it 'Send one request to slack' do
        expect(SlackUtils::SingletonClient.instance).to receive(:find_channel_id).with(bot.channel).and_return('ok!').once
        10.times.each { bot.channel_id }
      end

      it 'Update database.' do
        allow(SlackUtils::SingletonClient.instance).to receive(:find_channel_id).and_return('ok!')
        expect {
          subject
        }.to change {
          bot.reload.attributes['channel_id']
        }.from(nil).to('ok!')
      end
    end
  end

  describe '#execute_function' do
    subject do
      bot.execute_function(function, arguments: arguments)
    end

    let :function do
      'onTalk'
    end

    let :arguments do
      [name, text]
    end

    let :name do
      'akr'
    end

    let :text do
      'media arts.'
    end

    it 'Return script eval.' do
      expect(subject).to eq("#{name}-#{text}")
    end

    context 'when call module script' do
      let :script do
        'function onTalk(name, text) { return oreo(); }'
      end

      it 'Return module call result' do
        expect(subject).to eq('oreo!!')
      end
    end

    context 'when call api in script' do
      let :script do
        'function onTalk(name, text) { return api.version; }'
      end

      it 'Return api result.' do
        expect(subject).to eq(Bots::API::API_VERSION)
      end
    end

    context 'with compile error script' do
      let :script do
        'i am bug code!!! uhooooo!!'
      end

      it 'Raise Unexpected identifier.' do
        subject
        expect(bot.current_error).to include('Unexpected identifier')
      end
    end

    context 'with error script' do
      let :script do
        'function onTalk(name, text){ nemui() }'
      end

      it 'Raise Error.' do
        subject
        expect(bot.current_error).to include('not defined')
      end
    end

    context 'with infinity loop script' do
      let :script do
        'function onTalk(name, text){ while(1){} }'
      end

      it 'Raise timeout.' do
        subject
        expect(bot.current_error).to include('Timed Out')
      end
    end
  end

  describe '.create' do
    it 'create storage' do
      expect {
        Bot.create!(name: '1', script: '1', channel: '1', default_icon: '1', user: User.find(1))
      }.to change(Storage, :count).by(1)
    end
  end
end
