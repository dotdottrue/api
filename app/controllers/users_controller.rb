class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :pubkey]

  def index
    @users = User.all
  end

  def show
  end

  def pubkey
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if User.exists?(:name => @user.name)
        format.json { render json: '{ "status":"501" }', status: 501 }
      elsif @user.save
        format.json { render json: '{ "status":"200" }', status: 200 }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: 500 }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        #format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        #format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.friendly.find(params[:id])
    if @user.destroy
      respond_to do |format|
        format.json { render json: '{ "status":"200" }', status: 200 }
      end
    else
      format.json { render json: '{ "status":"500" }', status: 500 }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :slug, :salt_masterkey, :pubkey_user, :privkey_user_enc)
    end
end
