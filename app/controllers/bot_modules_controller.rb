class BotModulesController < ApplicationController
  before_action :authenticated!, except: [:index, :show]
  before_action :set_bot_module, only: [:show, :edit, :update, :destroy]
  before_action :check_permission!, except: [:index, :new, :create]

  # GET /bot_modules
  def index
    @bot_modules = BotModule.all
  end

  # GET /bot_modules/1
  def show
  end

  # GET /bot_modules/new
  def new
    @bot_module = BotModule.new
  end

  # GET /bot_modules/1/edit
  def edit
  end

  # POST /bot_modules
  def create
    @bot_module = BotModule.new(bot_module_params).tap do |bot_module|
      bot_module.user = current_user
    end

    respond_to do |format|
      if @bot_module.save
        format.html { redirect_to @bot_module, notice: 'Bot was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /bot_modules/1
  def update
    respond_to do |format|
      if @bot_module.update(bot_module_params)
        format.html { redirect_to @bot_module, notice: 'Bot was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /bots/1
  def destroy
    @bot_module.destroy
    respond_to do |format|
      format.html { redirect_to bot_modules_url, notice: 'Bot was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_bot_module
    @bot_module = BotModule.find(params[:id])
  end

  # Check Permission.
  def check_permission!
    case action_name
      when 'show'
        redirect_to root_path if @bot_module.permission == BotModules::Permissions::PRIVATE_MODULE && !@bot_module.owner?(current_user)
      when 'edit', 'update', 'destroy'
        redirect_to root_path unless @bot_module.owner?(current_user)
      else
        raise "Unknown action #{action_name}"
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bot_module_params
    params.require(:bot_module).permit(:name, :description, :permission, :script)
  end
end
