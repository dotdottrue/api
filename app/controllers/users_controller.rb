class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :pubkey]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def pubkey
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if User.exists?(name: @user.name)
        format.json { render json: @status = '{"status":"501"}' }
      else
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          #add add statuscode
          render status: 200
          # format.json { render json: status = '{ "status":"200" }' }
        else
          format.html { render :new }
          render status: 500
          #format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      #add statuscodes falls wir die funktion mit einbauen
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      render status: 200
      #format.json { render json: status = '{ "status":"200" }' }
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
