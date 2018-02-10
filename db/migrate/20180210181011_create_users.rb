class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :status, default: 'ACTIVE'
      t.timestamps
    end
  end
end
