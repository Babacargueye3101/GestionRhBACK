class ChangeStatusTypeInAppointments < ActiveRecord::Migration[6.1]
  def change
    def up
      change_column :appointments, :status, :string
    end

    def down
      change_column :appointments, :status, :integer
    end
  end
end
