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
  include TransactionType

  validates :name, :hint, :nominal_code, :transaction_type, :active, presence: true
  validates :name, uniqueness: true

  # Define the transaction type enum by including.
  attribute :active, :boolean, default: true

  belongs_to :nominal_code, class_name: 'Finance::NominalCode'

  def self.active
    where(active: true)
  end
end
