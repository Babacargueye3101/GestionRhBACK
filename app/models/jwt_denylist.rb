class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  belongs_to :user
end
