class AddContraTypeToEmployee < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :contrat_type, :string
  end
end
