class CreateCompagnies < ActiveRecord::Migration[6.1]
  def change
    create_table :compagnies do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :countrie
      t.string :zipCode
      t.string :phoneNumber
      t.string :email
      t.string :website
      t.string :desciption

      t.timestamps
    end
  end
end
