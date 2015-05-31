class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender
      t.text :cipher
      t.integer :iv
      t.string :key_recipient_enc
      t.string :sig_recipient
      t.string :timestamp
      t.string :recipient
      t.string :sig_service

      t.timestamps null: false
    end
  end
end
