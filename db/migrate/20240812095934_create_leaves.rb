class CreateLeaves < ActiveRecord::Migration[6.1]
  def change
    create_table :leaves do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :leave_type
      t.date :start_date
      t.date :end_date
      t.text :reason
      t.string :status
      t.integer :days_taken
      t.text :comments

      t.timestamps
    end
  end
end
