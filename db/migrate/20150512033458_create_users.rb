class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid,       :limit => 128, :index => true, :unique => true
      t.string :name,      :limit => 128
      t.string :image_url, :limit => 512

      t.timestamps null: false
    end
  end
end
