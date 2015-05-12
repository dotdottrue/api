json.array!(@users) do |user|
  json.extract! user, :id, :identity, :password, :salt_masterkey, :pubkey_user, :privkey_user_enc
  json.url user_url(user, format: :json)
end
