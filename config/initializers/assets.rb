# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  jquery.lightbox-0.5.js

  admin.js
  admin/proposals/call_templates.js
  admin/questionnaires/questionnaire_templates.js
  admin/staffing_templates.js
  admin/team_member_fields.js
  admin/users.js

  admin.css
  admin/dashboard.css
  login.css
  jquery.lightbox-0.5.css
)
