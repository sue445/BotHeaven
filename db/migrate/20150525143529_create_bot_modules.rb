class CreateBotModules < ActiveRecord::Migration
  def change
    create_table :bot_modules do |t|
      t.references :user, index: true
      t.string :name,        :limit => 32
      t.string :description, :limit => 128
      t.text :script

      t.integer :permission
      t.timestamps null: false
    end
    add_foreign_key :bot_modules, :users
  end
end
