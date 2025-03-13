class UpdateUserPermissions < ActiveRecord::Migration[7.1]
  def change
    # Ajouter les nouveaux champs
    add_column :users, :can_see_shop, :boolean, default: false
    add_column :users, :can_see_client, :boolean, default: false
    add_column :users, :can_see_configuration, :boolean, default: false
    add_column :users, :can_see_subs, :boolean, default: false

    # Renommer les champs existants
    rename_column :users, :can_see_formation, :can_see_vente
    rename_column :users, :can_see_candidature, :can_see_reservation
    rename_column :users, :can_see_paies, :can_see_dispo
  end
end
