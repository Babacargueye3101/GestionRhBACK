class AddCompanyIdToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_reference :appointments, :compagny, null: false, foreign_key: true
  end
end
