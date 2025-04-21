DeviseTokenAuth.setup do |config|
  config.enable_standard_devise_support = true
  config.change_headers_on_each_request = false
  config.token_lifespan = 2.weeks
  config.allow_insecure_token_lookup = true # ici c'est valide
end