# Configure Action Cable paths
Rails.application.config.autoload_paths += %W[#{Rails.root}/app/channels]
Rails.application.config.autoload_paths += %W[#{Rails.root}/app/channels/application_cable]
Rails.application.config.autoload_paths += %W[#{Rails.root}/app/channels/notification_channel]

# Configure Action Cable
Rails.application.config.action_cable.mount_path = "/cable"
