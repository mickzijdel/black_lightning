# == Schema Information
#
# Table name: finance_expenditure_requests
#
# *id*::                     <tt>bigint, not null, primary key</tt>
# *name*::                   <tt>string(255), not null</tt>
# *submitter_notes*::        <tt>text(65535)</tt>
# *business_manager_notes*:: <tt>text(65535)</tt>
# *amount_cents*::           <tt>integer, default(0), not null</tt>
# *amount_currency*::        <tt>string(255), default("GBP"), not null</tt>
# *budget_line_id*::         <tt>bigint, not null</tt>
# *user_id*::                <tt>integer, not null</tt>
# *bank_information_id*::    <tt>bigint</tt>
# *request_status*::         <tt>integer</tt>
# *proof_status*::           <tt>integer, not null</tt>
# *created_at*::             <tt>datetime, not null</tt>
# *updated_at*::             <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
class Finance::ExpenditureRequest < ApplicationRecord
  has_paper_trail

  after_create :update_status_after_create
  after_save :update_status_after_save

  validates :name, :amount_cents, :request_status, :proof_status, presence: true
  validates :amount_cents, numericality: { only_integer: true, less_than: 0 }
  validates :name, uniqueness: { scope: :budget_line_id }

  monetize :amount_cents

  enum request_status: { 'unchecked' => 0, 'has_issue' => 1, 'checked' => 2, 'sent_to_eusa' => 3 }, _prefix: :request
  enum proof_status: { 'not_submitted' => 0, 'submitted' => 1, 'has_issue' => 2, 'checked' => 3, 'sent_to_eusa' => 4 }, _prefix: :proof

  belongs_to :budget_line, class_name: 'Finance::BudgetLine'
  belongs_to :user, optional: true
  belongs_to :bank_information, class_name: 'Finance::BankInformation'
  # TODO: figure out how update_only works with creating.
  accepts_nested_attributes_for :bank_information, allow_destroy: true#, update_only: true

  has_one :budget, through: :budget_line, autosave: false

  # HOW TO DO PROOFS
  # Maybe attachments, and set up the ability file so that no one can see the attachments where
  # item is of class Expenditure or Income request after the grid, and then override that once more
  # based on access to those expenditure and income requests
  # Also omit tags since they're quite pointless.

  def update_status_after_save
    if proof_status.nil? || proof_status == 'not_sbmitted'
      # If has proof, proof_status is submitted
      # else, proof_status is not_submitted.
      save
    end
  end

  def update_status_after_create
    if request_status.nil?
      update(request_status: 'unchecked')
    end

    save
  end
end
