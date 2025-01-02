class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    create_table :users do |t|
      t.string :name, null: false
    end
  end

  def down
    drop_table :users
  end
end
