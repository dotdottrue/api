class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    response_timestamp = params[:timestamp].to_i

    user_signature = Base64.strict_decode64(params[:sig_user])
    document = params[:user_id].to_s + response_timestamp.to_s

    if timestampValidation(response_timestamp)
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
        #Message.where(recipient: params[:user_id]).destroy
      else
        render status: 503
        puts "##################SIGNATURe invalid##################"
        puts "#####################################################"
      end
    else
      render status: 501
    end
  end

  def show
  end

  def new
    @message = Message.new
  end

  def edit
  end

  def create
    @message = Message.new(message_params)

    user_signature = Base64.strict_decode64(@message.sig_service)
    @user = User.find_by_name(@message.sender)
    digest = OpenSSL::Digest::SHA256.new
    pubkey = OpenSSL::PKey::RSA.new(Base64.strict_decode64(@user.pubkey_user))

    sig_document = @message["sender"].to_s + Base64.strict_decode64(@message["cipher"]).to_s + Base64.strict_decode64(@message["iv"]).to_s + Base64.strict_decode64(@message["key_recipient_enc"]).to_s + @message["timestamp"].to_s + @message["recipient"].to_s

    respond_to do |format|
      if timestampValidation(@message.timestamp.to_i)
        puts "#####################################################"
        puts "###################SIGNATURE CHECK###################"
        puts "#####################################################"
        if pubkey.verify digest, Base64.strict_decode64(@message.sig_service), sig_document
          puts "###################SIGNATURE Valid###################"
          puts "#####################################################"
          puts "testen wa nochmal"
          puts @message["sender"].to_s
          @message.save

          #format.html { redirect_to @message, notice: 'Message was successfully created.' }
          format.json { render json: '{ "status":"200" }', status: 200 }
        else
          puts "##################SIGNATURe invalid##################"
          puts "#####################################################"
          format.json { render json: '{ "status":"503" }', status: 503 }
        end
      else
        format.json { render json: '{ "Nachricht":"Status 500 - Zeitüberschreitung bei der Anfrage." }', status: 500 }
      end
    end
  end

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

  def destroy
    @delete_msg = Message.find(params[:id])
    @delete_msg.destroy
    respond_to do |format|
      #format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender, :cipher, :iv, :key_recipient_enc, :sig_recipient, :timestamp, :recipient, :sig_service)
    end
end
