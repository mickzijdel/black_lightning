# == Schema Information
#
# Table name: finance_budgets
#
# *id*::              <tt>bigint, not null, primary key</tt>
# *title*::           <tt>string(255), not null</tt>
# *notes*::           <tt>text(65535)</tt>
# *event_id*::        <tt>bigint</tt>
# *budget_category*:: <tt>integer, not null</tt>
# *status*::          <tt>integer, not null</tt>
# *created_at*::      <tt>datetime, not null</tt>
# *updated_at*::      <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
class Finance::Budget < ApplicationRecord
  has_paper_trail

  validates :title, :notes, :budget_category, :status, presence: true
  validates :title, uniqueness: true

  enum budget_category: { 'Event' => 0, 'Committee' => 1, 'Fixed' => 2, 'Other' => 3 }
  enum status: { 'Initial' => 0, 'Modified' => 1, 'Checked' => 2 }

  belongs_to :event, class_name: 'Event', optional: true

  has_many :team_members, -> { includes(:user) }, class_name: '::TeamMember', as: :teamwork, dependent: :destroy
  has_many :users, through: :team_members

  accepts_nested_attributes_for :team_members, reject_if: :all_blank, allow_destroy: true
end
