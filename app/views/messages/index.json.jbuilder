json.array!(@messages) do |message|
  json.extract! message, :id, :sender, :cipher, :iv, :key_recipient_enc, :sig_recipient, :timestamp, :recipient, :sig_service
  json.url message_url(message, format: :json)
end
