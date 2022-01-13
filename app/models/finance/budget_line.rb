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

  validates :name, :allocated_cents, :transaction_type, presence: true
  validates :name, uniqueness: { scope: :budget_id }

  validate :correct_sign
  validate :allocated_not_below_actual

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
  
  def requests_attached?
    expenditure_requests.size.positive? || false # TODO: Has income
  end

  private 

  # Validations

  def correct_sign
    # Checks that the sign stays appropriate when the budget line already has expenditure_requests or income attached.
    # Return because the allocated error is irrelevant if the type is wrong.
    if expense? && false # TODO: Has income
      errors.add(:transaction_type, 'is marked as expense but has income requests attached. Please change the type back to income.')
      return
    elsif income? && expenditure_requests.size.positive?
      errors.add(:transaction_type, 'is marked as income but has expenditure requests attached. Please change the type back to expense.')
      return
    end

    # Checks that allocated_cents is 0 or bigger than 0 when income, and 0 or smaller than 0 when expenditure.
    if expense? && allocated_cents.positive?
      errors.add(:allocated, 'is a positive number despite being expenditure.')
    elsif income? && allocated_cents.negative?
      errors.add(:allocated, 'is a negative number despite being income.')
    end
  end

  # Checks that for expenses, the allocated amount is more than the actual amount.
  def allocated_not_below_actual
    # Actual and allocated are negative, so we fail if actual is an even lower number than allocated.
    if expense? && actual_cents < allocated_cents
      errors.add(:allocated, "must be larger than the amount currently spend, which is #{actual}")
    end
  end
end
