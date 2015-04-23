class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :name
      t.references :school, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
