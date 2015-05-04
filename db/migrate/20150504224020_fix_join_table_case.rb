class FixJoinTableCase < ActiveRecord::Migration
  def change
    rename_table :Courses_Schedules, :courses_schedules
  end
end
