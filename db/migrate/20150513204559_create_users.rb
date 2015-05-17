class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :slug
      t.string :salt_masterkey
      t.string :pubkey_user
      t.string :privkey_user_enc

      t.timestamps null: false
    end
    add_index :users, :slug, unique: true
  end
end
