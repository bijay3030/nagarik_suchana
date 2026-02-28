class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, if_not_exists: true do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.integer :role, null: false, default: 0
      t.string :jti, null: false, default: ""
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :users, :jti, unique: true unless index_exists?(:users, :jti)
    add_index :users, :role unless index_exists?(:users, :role)
    add_index :users, :created_at unless index_exists?(:users, :created_at)
    add_index :users, [:role, :created_at] unless index_exists?(:users, %i[role created_at])
    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end
end
