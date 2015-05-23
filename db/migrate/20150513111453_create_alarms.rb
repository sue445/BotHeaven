class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.string :name,               :limit => 32
      t.string :callback_function,  :limit => 128
      t.integer :minutes
      t.boolean :repeat
      t.datetime :wake_at,          index: true
      t.references :bot,            index: true

      t.timestamps null: false
    end
    add_foreign_key :alarms, :bots
    add_index :alarms, [:bot_id, :name], unique: true
  end
end
