SecureHeaders::Configuration.default do |config|
  config.cookies = SecureHeaders::OPT_OUT
  config.hsts = SecureHeaders::OPT_OUT
  config.x_frame_options = SecureHeaders::OPT_OUT
  config.x_content_type_options = SecureHeaders::OPT_OUT
  config.x_xss_protection = SecureHeaders::OPT_OUT
  config.x_download_options = SecureHeaders::OPT_OUT
  config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
  config.referrer_policy = SecureHeaders::OPT_OUT

  config.csp = {
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline' 'unsafe-eval' https: http:),
    style_src: %w('self' 'unsafe-inline' https:),
    img_src: %w('self' data: https:),
    font_src: %w('self' data: https:),
    connect_src: %w('self' https: wss:),
    media_src: %w('self'),
    object_src: %w('self'),
    frame_src: %w('self' https://galsentech.netlify.app),
    worker_src: %w('self'),
    base_uri: %w('self'),
    form_action: %w('self'),
    frame_ancestors: %w('self' https://galsentech.netlify.app)
  }
end
