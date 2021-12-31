# == Schema Information
#
# Table name: finance_nominal_codes
#
# *id*::          <tt>bigint, not null, primary key</tt>
# *code*::        <tt>string(255), not null</tt>
# *name*::        <tt>string(255), not null</tt>
# *hint*::        <tt>text(65535), not null</tt>
# *description*:: <tt>text(65535)</tt>
# *active*::      <tt>boolean, not null</tt>
# *created_at*::  <tt>datetime, not null</tt>
# *updated_at*::  <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
class Finance::NominalCode < ApplicationRecord
  validates :code, :name, :description, presence: true
  validates :code, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }, length: { is: 6 }

  attribute :active, :boolean, default: true

  has_many :transaction_categories, class_name: 'Finance::TransactionCategory'

  default_scope { order(:code) }

  def self.active
    where(active: true)
  end

  def label
    return "#{code} - #{name}"
  end
end
