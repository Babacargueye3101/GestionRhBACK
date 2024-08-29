class RenameTypeToAppointmentTypeInAppointments < ActiveRecord::Migration[6.1]
  def change
    rename_column :appointments, :type, :appointment_type
  end
end
