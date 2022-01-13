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
  include ValidationHelper

  has_paper_trail

  before_validation :parse_bank_information
  after_create :update_status_after_create
  after_save :update_status_after_save

  validates :name, :amount_cents, :request_status, :proof_status, :reimbursement_method, :expense_date, presence: true
  validates :name, format: ValidationHelper::filename_validation_regex
  validates :amount, numericality: { less_than: 0 }
  validates :name, uniqueness: { scope: :budget_line_id }

  monetize :amount_cents

  enum request_status: { 'unchecked' => 0, 'has_issue' => 1, 'checked' => 2, 'sent_to_eusa' => 3 }, _prefix: :request
  enum proof_status: { 'not_submitted' => 0, 'submitted' => 1, 'has_issue' => 2, 'checked' => 3, 'sent_to_eusa' => 4 }, _prefix: :proof
  enum reimbursement_method: { 'bacs' => 0, 'invoice' => 1 }

  belongs_to :budget_line, class_name: 'Finance::BudgetLine'
  belongs_to :user, optional: true
  belongs_to :transaction_category, class_name: 'Finance::TransactionCategory'
  belongs_to :bank_information, class_name: 'Finance::BankInformation', optional: true

  accepts_nested_attributes_for :bank_information, allow_destroy: true

  has_one :budget, through: :budget_line, autosave: false

  has_one_attached :proof

  # Returns budgets that have been checked or sent to EUSA
  def self.approved
    where(request_status: ['checked', 'sent_to_eusa'])
  end

  def setup_bank_information
    build_bank_information if self.bank_information.nil?
  end

  # Callbacks

  def parse_bank_information
    if invoice?
      self.bank_information = nil
    end
  end

  def update_status_after_save
    # If there was no status (on new) or the proof status was not submitted, 
    # and there is now something submitted, set the status to submitted.
    new_proof_status = Finance::ExpenditureRequest.proof_statuses[proof_status]

    if proof_status.nil? || proof_status == 'not_sbmitted'
      if proof.attached?
        new_proof_status = 1
      else
        new_proof_status = 0
      end
    end

    if proof.attached?
      # If the proof has has changed, set the status back to submitted to reset it.
      if proof.new_record?
        new_proof_status = 1
      end

      # Standardise the filename for the proof so they are easily linked to the correct expenditure.
      proof.blob.update(filename: "#{expense_date} - #{budget_line&.budget&.title.presence || 'No Budget'} - #{name} Proof.#{proof.filename.extension}")
    end

    update_columns(proof_status: new_proof_status)
  end

  def update_status_after_create
    if request_status.nil?
      update(request_status: 'unchecked')
    end
  end
end
