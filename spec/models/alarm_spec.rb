require 'rails_helper'

RSpec.describe Alarm, type: :model do
  fixtures :users
  fixtures :bots
  fixtures :alarms

  let :alarm do
    Alarm.find(1)
  end

  describe '#name' do
    it 'Length Range in 1,32' do
      expect(alarm).to validate_length_of(:name).is_at_least(1).is_at_most(32)
    end
  end

  describe '#callback_function' do
    it 'Length Range in 1,128' do
      expect(alarm).to validate_length_of(:callback_function).is_at_least(1).is_at_most(128)
    end
  end

  describe '#minutes' do
    it 'Presence' do
      expect(alarm).to validate_presence_of(:minutes)
    end
  end

  describe '#bot' do
    it 'Presence' do
      expect(alarm).to validate_presence_of(:bot)
    end
  end

  describe '#wake_at' do
    context 'when save' do
      it 'Updated' do
        expect {
          alarm.update!(minutes: alarm.minutes + 10)
        }.to change {
          alarm.wake_at
        }
      end
    end
  end

  describe '#wake' do
    subject do
      alarm.wake
    end

    it 'Enqueue bot job.' do
      expect(JobDaemon).to receive(:enqueue)
      subject
    end

    it 'destroy alarm' do
      expect {
        subject
      }.to change {
        alarm.destroyed?
      }.from(false).to(true)
    end

    context 'repeat alarm' do
      let :alarm do
        Alarm.find(2)
      end

      it 'update wake_at' do
        expect {
          subject
        }.to change {
          alarm.wake_at
        }
      end

      it 'destroy alarm' do
        expect {
          subject
        }.not_to change {
          alarm.destroyed?
        }.from(false)
      end
    end
  end

  describe '.check!' do
    subject do
      Alarm.check!
    end

    it 'proc alarms' do
      expect {
        subject
      }.to change(Alarm, :count)
    end
  end

  describe '.set!' do
    it 'Create alarm' do
      expect { Alarm.set!('test', Bot.find(1), 'hoge', 1, false) }.to change(Alarm, :count).by(1)
    end

    context 'When exist alarm' do
      let! :alarm do
        Alarm.set!('test', Bot.find(1), 'hoge', 1, false)
      end

      it 'Update alarm' do
        expect {
          Alarm.set!(alarm.name, alarm.bot, 'fuga', 0, false)
        }.to change {
          alarm.reload.callback_function
        }.from('hoge').to('fuga')
      end
    end
  end
end
