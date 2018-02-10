class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.string :week_number
      t.string :day
      t.date :start_date
      t.string :virtue
      t.string :description
      t.string :website
      t.string :sunday
      t.string :monday
      t.string :tuesday
      t.string :wednesday
      t.string :thursday
      t.string :friday
      t.string :saturday

      t.timestamps
    end
  end
end
