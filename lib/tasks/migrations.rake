require "#{Rails.root}/lib/tasks/logic/migrations"

namespace :migrations do
  # I don't have any better name, but this is just to fix a failed migration.
  # :nocov:
  desc 'Fixes the editing deadline on proposals by defaulting to the submission deadline'
  task fix_editing_deadline: :environment do
    amount = Tasks::Logic::Migrations.fix_editing_deadline
    puts "Fixed the submission deadline for #{amount} calls."
  end
  
  namespace :active_storage do
    desc 'Migrate the Venue image from Paperclip to ActiveStorage'
    task venue_image: :environment do
      Tasks::Logic::Migrations.venue_image
      p 'Migrated all Venue images.'
    end
  end
  # :nocov:
end
