class AddIndexToEventsAuthor < ActiveRecord::Migration[8.0]
  def change
    add_index :events, :author
  end
end
