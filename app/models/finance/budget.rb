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
  include ValidationHelper
  has_paper_trail

  after_initialize :add_default_budget_lines

  validates :title, :notes, :budget_category, :status, :eutc_grant_amount, :eutc_grant_amount_cents, presence: true
  validates :title, uniqueness: true, format: ValidationHelper::filename_validation_regex
  validates :eutc_grant_amount, numericality: { greater_than_or_equal_to: 0 }

  attribute :is_draft, :boolean, default: true

  enum budget_category: { 'event' => 0, 'committee' => 1, 'fixed' => 2, 'other' => 3 }
  enum status: { 'initial' => 0, 'modified' => 1, 'checked' => 2 }

  belongs_to :event, class_name: 'Event', optional: true

  has_many :team_members, -> { includes(:user) }, class_name: '::TeamMember', as: :teamwork, dependent: :restrict_with_error
  has_many :users, through: :team_members
  has_many :budget_lines, class_name: 'Finance::BudgetLine', dependent: :restrict_with_error
  has_many :expenditure_requests, class_name: 'Finance::ExpenditureRequest', through: :budget_lines

  accepts_nested_attributes_for :team_members, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :budget_lines, reject_if: :all_blank, allow_destroy: true

  validates_associated :budget_lines

  monetize :eutc_grant_amount_cents

  # Only budgets that are not draft and have been checked at least once.
  def self.active
    where(is_draft: false).where(status: ['modified', 'checked'])
  end

  ##
  # Totals
  ##
  monetize :total_allocated_expenses_cents
  monetize :total_allocated_income_cents
  monetize :total_allocated_cents

  monetize :total_actual_expenses_cents
  monetize :total_actual_income_cents
  monetize :total_actual_cents

  monetize :total_amount_to_spend_cents
  monetize :total_amount_left_cents

  def total_allocated_expenses_cents
    budget_lines.expense.pluck(:allocated_cents).sum
  end

  def total_allocated_income_cents
    budget_lines.income.pluck(:allocated_cents).sum
  end

  def total_allocated_cents
    budget_lines.pluck(:allocated_cents).sum
  end

  # TODO: Rename to expenditure
  def total_actual_expenses_cents
    Finance::ExpenditureRequest.where(budget_line: budget_lines.ids).request_approved.pluck(:amount_cents).sum
  end

  def total_actual_income_cents
    0
  end

  def total_actual_cents
    total_actual_expenses_cents + total_actual_income_cents
  end

  def total_amount_to_spend_cents
    # TODO: Total income requests that count towards the total amount to spend
    eutc_grant_amount_cents + 0
  end

  def total_amount_left_cents
    # Plus because expenditure is negative.
    total_amount_to_spend_cents + total_actual_expenses_cents
  end

  # If the budget is first initialized, add the default lines such as rights, tech, set, etc.
  def add_default_budget_lines
    return unless new_record? && budget_lines.empty?

    Finance::BudgetLine::DEFAULT_NAMES.each do |name|
      budget_lines << Finance::BudgetLine.new(name: name, allocated: 0, transaction_type: 'expense')
    end
  end

  def as_json(options = {})
    defaults = {include: [:budget_lines, team_members: { methods: [:user_name] }] }

    options = merge_hash(defaults, options)

    super(options)
  end
end
