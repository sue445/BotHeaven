require 'rails_helper'

RSpec.describe BotsController, type: :controller do
  fixtures :users
  fixtures :bots

  let :bot do
    Bot.find(1)
  end

  let :user do
    User.find(1)
  end

  let :valid_attributes do
    {
      name:         'valid_attributes',
      channel:      'random',
      default_icon: 'tikuwa',
      permission:   2,
      script:       'function initialize(){};',
      user:         user
    }
  end

  let :invalid_attributes do
    {name: 'aaaaaaaaaaaaa' * 10}
  end

  before(:each) do
    login(user)
  end

  describe "GET #index" do
    subject do
      get :index
      response
    end

    it 'Render index.' do
      expect(subject).to render_template(:index)
    end
  end

  describe "GET #new" do
    subject do
      get :new
      response
    end

    it 'Render new.' do
      expect(subject).to render_template(:new)
    end
  end


  describe "GET #show" do
    subject do
      get :show, id: bot.to_param
      response
    end

    it 'Render show.' do
      expect(subject).to render_template(:show)
    end

    context 'When private bot' do
      let :bot do
        Bot.find(2)
      end

      it 'Redirect to root' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    subject do
      get :edit, id: bot.to_param
      response
    end

    it 'Render edit.' do
      expect(subject).to render_template(:edit)
    end

    context 'When private bot' do
      let :bot do
        Bot.find(2)
      end

      it 'Redirect to root' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end


  describe "POST #create" do
    context "with valid params" do
      subject do
        post :create, {:bot => valid_attributes}
      end

      it "creates a new Bot" do
        expect {
          subject
        }.to change(Bot, :count).by(1)
      end

      it "assigns a newly created bot as @bot" do
        subject
        expect(assigns(:bot)).to be_a(Bot)
        expect(assigns(:bot)).to be_persisted
      end

      it "redirects to the created bot" do
        subject
        expect(response).to redirect_to(Bot.last)
      end

      it 'enqueue initializer job.' do
        expect(JobDaemon).to receive(:enqueue)
        subject
      end

      it 'invite bot to channel.' do
        expect(SlackUtils::SingletonClient.instance).to receive(:invite_channel)
        subject
      end
    end

    context "with invalid params" do
      subject do
        post :create, {:bot => invalid_attributes}
      end

      it "assigns a newly created but unsaved bot as @bot" do
        subject
        expect(assigns(:bot)).to be_a_new(Bot)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'alfa', channel: 'alfa_test' }
      }

      let :bot do
        bot = Bot.create! valid_attributes
      end

      subject do
        put :update, {:id => bot.to_param, :bot => new_attributes}
      end

      it "updates the requested bot" do
        subject
        bot.reload
        expect(bot.name).to eq('alfa')
      end

      it "assigns the requested bot as @bot" do
        subject
        expect(assigns(:bot)).to eq(bot)
      end

      it "redirects to the bot" do
        subject
        expect(response).to redirect_to(bot)
      end

      it 'enqueue initializer job.' do
        expect(JobDaemon).to receive(:enqueue)
        subject
      end

      it 'invite bot to channel.' do
        expect(SlackUtils::SingletonClient.instance).to receive(:invite_channel)
        subject
      end
    end

    context "with invalid params" do
      it "assigns the bot as @bot" do
        bot = Bot.create! valid_attributes
        put :update, {:id => bot.to_param, :bot => invalid_attributes}
        expect(assigns(:bot)).to eq(bot)
      end

      it "re-renders the 'edit' template" do
        bot = Bot.create! valid_attributes
        put :update, {:id => bot.to_param, :bot => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested bot" do
      bot = Bot.create! valid_attributes
      expect {
        delete :destroy, {:id => bot.to_param}
      }.to change(Bot, :count).by(-1)
    end

    it "redirects to the bots list" do
      bot = Bot.create! valid_attributes
      delete :destroy, {:id => bot.to_param}
      expect(response).to redirect_to(bots_url)
    end
  end
end
