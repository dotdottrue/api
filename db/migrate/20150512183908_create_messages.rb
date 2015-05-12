class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.int :identity
      t.text :cipher
      t.int :iv
      t.string :key_recipient_enc
      t.string :sig_recipient
      t.string :recipient
      t.string :sig_service

      t.timestamps null: false
    end
  end
end
