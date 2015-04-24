class CreateJoinTableScheduleCourse < ActiveRecord::Migration
  def change
    create_join_table :Schedules, :Courses do |t|
      # t.index [:schedule_id, :course_id]
      # t.index [:course_id, :schedule_id]
    end
  end
end
