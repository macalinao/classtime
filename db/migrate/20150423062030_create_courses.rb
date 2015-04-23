class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :number
      t.string :section
      t.string :days
      t.time :start_time
      t.time :end_time
      t.string :room
      t.string :instructor
      t.date :starts_at
      t.date :ends_at

      t.timestamps null: false
    end
  end
end
