# Be sure to restart your server when you modify this file.

# API-only apps may not load an assets pipeline.
return unless Rails.application.config.respond_to?(:assets)

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
