class Finance::TransactionCategory < ApplicationRecord
  validates :name, :hint, :nominal_code, :transaction_type, :active, presence: true
  validates :name, uniqueness: true

  attribute :active, :boolean, default: true
  enum transaction_type: { 'Expense' => 0, 'Income' => 1 }

  belongs_to :nominal_code, class_name: 'Finance::NominalCode'

  default_scope { where(active: true) }

  def self.active
    where(active: true)
  end

  def transaction_type_options
    ApplicationController.helpers.options_for_select(Finance::TransactionCategory.transaction_type_options_base, transaction_type)
  end

  def self.transaction_type_options
    ApplicationController.helpers.options_for_select(transaction_type_options_base)
  end

  def self.transaction_type_options_base
    transaction_types.map { |key, value| [key.titleize, Finance::TransactionCategory.transaction_types.key(value)] }
  end
end
