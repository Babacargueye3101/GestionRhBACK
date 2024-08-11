class AddGenderToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :gender, :string
    add_column :employees, :birthdate, :date
    add_column :employees, :cni_number, :string
  end
end
