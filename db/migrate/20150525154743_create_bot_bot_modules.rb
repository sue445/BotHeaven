class CreateBotBotModules < ActiveRecord::Migration
  def change
    create_table :bot_bot_modules do |t|
      t.references :bot, index: true
      t.references :bot_module, index: true

      t.timestamps null: false
    end
    add_foreign_key :bot_bot_modules, :bots
    add_foreign_key :bot_bot_modules, :bot_modules
  end
end
