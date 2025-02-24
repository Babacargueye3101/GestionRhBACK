class PersonnelShop < ApplicationRecord
  belongs_to :personnel
  belongs_to :shop, optional: true
  belongs_to :salon, optional: true
end
