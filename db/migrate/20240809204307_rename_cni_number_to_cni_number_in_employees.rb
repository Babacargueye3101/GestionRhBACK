class RenameCniNumberToCniNumberInEmployees < ActiveRecord::Migration[6.1]
  def change
    rename_column :employees, :cni_number, :cniNumber
  end
end
