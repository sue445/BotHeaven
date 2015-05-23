class BotsController < ApplicationController
  before_action :authenticated!, except: [:index, :show]
  before_action :set_bot, only: [:show, :edit, :update, :destroy]
  before_action :check_permission!, except: [:index, :new, :create]

  # GET /bots
  # GET /bots.json
  def index
    @bots = Bot.all
  end

  # GET /bots/1
  # GET /bots/1.json
  def show
  end

  # GET /bots/new
  def new
    @bot = Bot.new.tap do |bot|
      bot.script = <<'EOS'
function initialize() {
}

function onTalk(name, text) {
  if(text=="Hello!") {
    api.slack.talk("Bot Heaven!");
  }
}
EOS
    end
  end

  # GET /bots/1/edit
  def edit
  end

  # POST /bots
  # POST /bots.json
  def create
    @bot = Bot.new(bot_params).tap do |bot|
      bot.user = current_user
    end

    respond_to do |format|
      if @bot.save
        call_initializer
        invite_bot
        format.html { redirect_to @bot, notice: 'Bot was successfully created.' }
        format.json { render :show, status: :created, location: @bot }
      else
        format.html { render :new }
        format.json { render json: @bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bots/1
  # PATCH/PUT /bots/1.json
  def update
    respond_to do |format|
      if @bot.update(bot_params)
        call_initializer
        invite_bot
        format.html { redirect_to @bot, notice: 'Bot was successfully updated.' }
        format.json { render :show, status: :ok, location: @bot }
      else
        format.html { render :edit }
        format.json { render json: @bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bots/1
  # DELETE /bots/1.json
  def destroy
    @bot.destroy
    respond_to do |format|
      format.html { redirect_to bots_url, notice: 'Bot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Call bot initializer.
  def call_initializer
    JobDaemon.enqueue(JobDaemons::BotJob.new(@bot.id, 'initialize', []))
  end

  # Invite HeavenBot to bot channel.
  def invite_bot
    SlackUtils::SingletonClient.instance.invite_channel(@bot.channel_id, Bot.slack_bot_id, session[:token])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bot
    @bot = Bot.find(params[:id])
  end

  # Check Permission.
  def check_permission!
    case action_name
      when 'show'
        redirect_to root_path if @bot.permission == Bots::Permissions::PRIVATE_BOT && !@bot.owner?(current_user)
      when 'edit','update'
        redirect_to root_path if @bot.permission != Bots::Permissions::FREEDOM_BOT && !@bot.owner?(current_user)
      when 'destroy'
        redirect_to root_path unless @bot.owner?(current_user)
      else
        raise "Unknown action #{action_name}"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bot_params
    params.require(:bot).permit(:name, :channel, :default_icon, :permission, :script)
  end
end
