class AddFullnameToLeave < ActiveRecord::Migration[6.1]
  def change
    add_column :leaves, :full_name, :string
  end
end
