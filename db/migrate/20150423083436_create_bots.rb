class CreateBots < ActiveRecord::Migration
  def change
    create_table :bots do |t|
      t.string :name,         :limit => 32
      t.string :default_icon, :limit => 32
      t.string :channel,      :limit => 32
      t.string :channel_id,   :limit => 32
      t.text :current_error
      t.text :script
      t.integer :permission
      t.references :user, :index => true
      t.timestamps null: false
    end
  end
end
