require 'rails_helper'

RSpec.describe BotModulesController, type: :controller do
  fixtures :users
  fixtures :bots
  fixtures :bot_modules

  let :bot_module do
    BotModule.find(1)
  end

  let :user do
    User.find(1)
  end

  let :valid_attributes do
    {
      name:        'valid_attributes',
      description: 'random',
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
      get :show, id: bot_module.to_param
      response
    end

    it 'Render show.' do
      expect(subject).to render_template(:show)
    end

    context 'When private Module' do
      let :bot_module do
        BotModule.find(2)
      end

      it 'Redirect to root' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end

  describe "GET #edit" do
    subject do
      get :edit, id: bot_module.to_param
      response
    end

    it 'Render edit.' do
      expect(subject).to render_template(:edit)
    end

    context 'When not owner.' do
      let :bot_module do
        BotModule.find(3)
      end

      it 'Redirect to root' do
        expect(subject).to redirect_to(root_path)
      end
    end
  end


  describe "POST #create" do
    context "with valid params" do
      subject do
        post :create, {:bot_module => valid_attributes}
      end

      it "creates a new Module" do
        expect {
          subject
        }.to change(BotModule, :count).by(1)
      end

      it "assigns a newly created bot_module as @bot_module" do
        subject
        expect(assigns(:bot_module)).to be_a(BotModule)
        expect(assigns(:bot_module)).to be_persisted
      end

      it "redirects to the created bot_module" do
        subject
        expect(response).to redirect_to(BotModule.last)
      end
    end

    context "with invalid params" do
      subject do
        post :create, {:bot_module => invalid_attributes}
      end

      it "assigns a newly created but unsaved bot_module as @bot_module" do
        subject
        expect(assigns(:bot_module)).to be_a_new(BotModule)
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
        { name: 'alfa', description: 'alfa_test' }
      }

      let :bot_module do
        bot_module = BotModule.create! valid_attributes
      end

      subject do
        put :update, {:id => bot_module.to_param, :bot_module => new_attributes}
      end

      it "updates the requested bot_module" do
        subject
        bot_module.reload
        expect(bot_module.name).to eq('alfa')
        expect(bot_module.description).to eq('alfa_test')
      end

      it "assigns the requested bot_module as @bot_module" do
        subject
        expect(assigns(:bot_module)).to eq(bot_module)
      end

      it "redirects to the bot_module" do
        subject
        expect(response).to redirect_to(bot_module)
      end

      context 'When not owner.' do
        let :bot_module do
          BotModule.find(3)
        end

        it 'Redirect to root' do
          expect(subject).to redirect_to(root_path)
        end
      end
    end

    context "with invalid params" do
      it "assigns the bot_module as @bot_module" do
        bot_module = BotModule.create! valid_attributes
        put :update, {:id => bot_module.to_param, :bot_module => invalid_attributes}
        expect(assigns(:bot_module)).to eq(bot_module)
      end

      it "re-renders the 'edit' template" do
        bot_module = BotModule.create! valid_attributes
        put :update, {:id => bot_module.to_param, :bot_module => invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested bot_module" do
      bot_module = BotModule.create! valid_attributes
      expect {
        delete :destroy, {:id => bot_module.to_param}
      }.to change(BotModule, :count).by(-1)
    end

    it "redirects to the bot_modules list" do
      bot_module = BotModule.create! valid_attributes
      delete :destroy, {:id => bot_module.to_param}
      expect(response).to redirect_to(bot_modules_url)
    end

    context 'When not owner.' do
      let :bot_module do
        BotModule.find(3)
      end

      it 'Redirect to root' do
        expect(delete :destroy, {:id => bot_module.to_param}).to redirect_to(root_path)
      end
    end
  end
end
