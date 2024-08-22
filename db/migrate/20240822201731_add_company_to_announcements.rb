class AddCompanyToAnnouncements < ActiveRecord::Migration[6.1]
  def change
    add_reference :announcements, :compagny, null: false, foreign_key: true
  end
end
