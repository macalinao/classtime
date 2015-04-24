class AddCreditsAndSemesterToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :credits, :integer
    add_reference :courses, :semester, index: true
  end
end
