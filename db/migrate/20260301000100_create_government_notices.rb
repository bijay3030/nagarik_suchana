class CreateGovernmentNotices < ActiveRecord::Migration[8.0]
  def change
    create_table :government_notices do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :category, null: false
      t.date :effective_date, null: false
      t.integer :status, null: false, default: 0
      t.datetime :published_at
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :updater, null: true, foreign_key: { to_table: :users }
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :government_notices, :status
    add_index :government_notices, :category
    add_index :government_notices, :effective_date
    add_index :government_notices, :deleted_at, where: "deleted_at IS NOT NULL", name: "idx_gov_notices_deleted_at_not_null"
  end
end
