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

  validates :title, :notes, :budget_category, :status, presence: true
  validates :title, uniqueness: true, format: ValidationHelper::filename_validation_regex

  enum budget_category: { 'Event' => 0, 'Committee' => 1, 'Fixed' => 2, 'Other' => 3 }
  enum status: { 'Initial' => 0, 'Modified' => 1, 'Checked' => 2 }

  belongs_to :event, class_name: 'Event', optional: true

  has_many :team_members, -> { includes(:user) }, class_name: '::TeamMember', as: :teamwork, dependent: :restrict_with_error
  has_many :users, through: :team_members
  has_many :budget_lines, class_name: 'Finance::BudgetLine', dependent: :restrict_with_error

  accepts_nested_attributes_for :team_members, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :budget_lines, reject_if: :all_blank, allow_destroy: true

  validates_associated :budget_lines

  def self.active
    # TODO: Define this later once draft budgets exist.
    all
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
    Finance::ExpenditureRequest.where(budget_line: budget_lines.ids).approved.pluck(:amount_cents).sum
  end

  def total_actual_income_cents
    0
  end

  def total_actual_cents
    total_actual_expenses_cents + total_actual_income_cents
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
