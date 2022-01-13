# == Schema Information
#
# Table name: finance_budget_lines
#
# *id*::               <tt>bigint, not null, primary key</tt>
# *name*::             <tt>string(255), not null</tt>
# *allocated_cents*::  <tt>integer, default(0), not null</tt>
# *transaction_type*:: <tt>integer, not null</tt>
# *budget_id*::        <tt>bigint, not null</tt>
# *created_at*::       <tt>datetime, not null</tt>
# *updated_at*::       <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
class Finance::BudgetLine < ApplicationRecord
  include TransactionType

  has_paper_trail

  validate :correct_sign
  validates :name, :allocated_cents, :transaction_type, presence: true
  validates :name, uniqueness: { scope: :budget_id }

  # Define the transaction type enum by including.

  belongs_to :budget, class_name: 'Finance::Budget'

  has_many :expenditure_requests, class_name: 'Finance::ExpenditureRequest'

  monetize :allocated_cents
  monetize :actual_cents

  default_scope -> { order(:transaction_type) }

  # List of names that are added to a budget when initialized.
  DEFAULT_NAMES = %w[Rights Admin Publicity Tech Set Costume Props Contingency].freeze

  def name_with_budget
    "#{budget.title.presence} - #{name}"
  end

  def actual_cents
    if expense?
      return expenditure_requests.approved.pluck(:amount_cents).sum
    elsif income?
      # TODO
      0
    end
  end

  # Checks that allocated_cents is 0 or bigger than 0 when income, and 0 or smaller than 0 when expenditure.
  def correct_sign
    if transaction_type == 'expense' && allocated_cents > 0
      errors.add(:allocated, 'is a positive number despite being expenditure')
    elsif transaction_type == 'income' && allocated_cents < 0
      errors.add(:allocated, 'is a negative number despite being income')
    end
  end
end
