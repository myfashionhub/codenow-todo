class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :status
      t.float :duration
      t.datetime :deadline
      t.datetime :completed_at
      t.timestamps null: false
    end
  end
end
