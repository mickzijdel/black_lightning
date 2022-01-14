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
  after_save :update_status_after_save

  validates :name, :amount_cents, :request_status, :proof_status, :reimbursement_method, :expense_date, presence: true
  validates :name, format: ValidationHelper::filename_validation_regex
  validates :amount, numericality: { less_than: 0 }
  validates :name, uniqueness: { scope: :budget_line_id }

  validate :inform_eusa_present_when_checked

  monetize :amount_cents

  enum request_status: { 'unchecked' => 0, 'has_issue' => 1, 'checked' => 2, 'sent_to_eusa' => 3 }, _prefix: :request, _default: 'unchecked'
  enum proof_status: { 'not_submitted' => 0, 'submitted' => 1, 'has_issue' => 2, 'checked' => 3, 'sent_to_eusa' => 4 }, _prefix: :proof
  enum reimbursement_method: { 'bacs' => 0, 'invoice' => 1 }

  belongs_to :budget_line, class_name: 'Finance::BudgetLine'
  belongs_to :user, optional: true
  belongs_to :transaction_category, class_name: 'Finance::TransactionCategory'
  belongs_to :bank_information, class_name: 'Finance::BankInformation', optional: true

  accepts_nested_attributes_for :bank_information, allow_destroy: true

  has_one :budget, through: :budget_line, autosave: false

  has_one_attached :proof

  # Scopes

  def self.requires_attention
    where(request_status: 'unchecked').or(where(proof_status: 'submitted'))
  end

  def self.waiting_for_update
    self.where(request_status: ['has_issue']).or(self.where(proof_status: ['not_submitted', 'has_issue']))
  end

  def self.fully_approved
    return self.request_approved.proof_approved
  end

  # Returns requests that have been checked or sent to EUSA
  def self.request_approved
    where(request_status: ['checked', 'sent_to_eusa'])
  end

  # Returns requests with proofs that have been checked or sent to EUSA
  def self.proof_approved
    where(proof_status: ['checked', 'sent_to_eusa'])
  end

  # Helper
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
    # If the expenditure request has changed, set the status back to unchecked, unless the only changes are status updates.
    if saved_changes.except(:request_status, :proof_status, :updated_at, :submitter_notes, :business_manager_notes).any?
      update_columns(request_status: 0)
    end

    # Now look at the proof status.
    new_proof_status = Finance::ExpenditureRequest.proof_statuses[proof_status]

    if proof.attached?
      # If there was no status set yet, or the proof status was not submitted,
      # and there is now something submitted, set the status to submitted.
      # If the proof has has changed, set the status back to submitted to reset it.
      if proof_status.nil? || proof_status == 'not_sbmitted' || proof.new_record?
        new_proof_status = 1
      end

      # Standardise the filename for the proof so they are easily linked to the correct expenditure.
      proof.blob.update(filename: "#{expense_date} - #{budget_line&.budget&.title.presence || 'No Budget'} - #{name} Proof.#{proof.filename.extension}")
    else
      # If there is no longer a proof attached, set the status to match.
      new_proof_status = 0
    end

    update_columns(proof_status: new_proof_status)
  end

  # Validations

  def inform_eusa_present_when_checked
    if !request_unchecked? && inform_eusa.nil?
      errors.add(:inform_eusa, 'cannot be blank after checking.')
    end
  end
end