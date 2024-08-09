class AddSalaryToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :salary, :integer
  end
end
