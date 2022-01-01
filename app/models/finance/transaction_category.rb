# == Schema Information
#
# Table name: finance_transaction_categories
#
# *id*::               <tt>bigint, not null, primary key</tt>
# *name*::             <tt>string(255), not null</tt>
# *hint*::             <tt>text(65535), not null</tt>
# *description*::      <tt>text(65535)</tt>
# *nominal_code_id*::  <tt>bigint, not null</tt>
# *transaction_type*:: <tt>integer, not null</tt>
# *active*::           <tt>boolean, not null</tt>
# *created_at*::       <tt>datetime, not null</tt>
# *updated_at*::       <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
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
