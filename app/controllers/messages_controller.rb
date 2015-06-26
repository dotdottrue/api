class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    #@messages = Message.all
    response_timestamp = params[:timestamp].to_i

    user_signature = Base64.strict_decode64(params[:sig_user])
    document = params[:user_id].to_s + response_timestamp.to_s

    if timestampValidation(response_timestamp)
      #check/validate signature at this point
      @user = User.find_by_name(params[:user_id])
      digest = OpenSSL::Digest::SHA256.new
      pubkey = OpenSSL::PKey::RSA.new(Base64.strict_decode64(@user.pubkey_user))
      
      puts "#####################################################"
      puts "###################SIGNATURE CHECK###################"
      puts "#####################################################"

      if pubkey.verify digest, user_signature, document
        puts "###################SIGNATURE Valid###################"
        puts "#####################################################"

        @messages = Message.where(recipient: params[:user_id])
        #Message.where(:recipient => params[:user_id]).destroy_all
      else
        render status: 503
        puts "##################SIGNATURe invalid##################"
        puts "#####################################################"
      end
    else
      render status: 501
    end
  end
      #@messages = Message.where(:recipient => params[:user_id])
    # if timestampValidation(response_timestamp)
    #   #signature must be checked at this point
    #   @user = User.find_by_name(params[:user_id])
    #   #if signature is valid, open the message which the user want to have
    
    #   @messages = Message.where(:recipient => params[:user_id])
    # else

  #   end
  # end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if timestampValidation(@message.timestamp.to_i)
        if @message.save
          format.html { redirect_to @message, notice: 'Message was successfully created.' }
          render status: 200
          # format.json { render json: @status = '{ "status":"200" }' }
        else
          format.html { render :new }
          render status: 503
          # format.json { render json: @status = '{ "status":"503" }' }
        end
      else
        render status: 500
        # format.json { render json: @status = '{ "status":"500" }' }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender, :cipher, :iv, :key_recipient_enc, :sig_recipient, :timestamp, :recipient, :sig_service)
    end
end
