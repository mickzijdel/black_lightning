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
FactoryBot.define do
  factory :finance_transaction_category, class: 'Finance::TransactionCategory' do
    name { generate(:random_name) }
    hint { generate(:random_text) }
    description { generate(:random_text) }
    association :nominal_code, factory: :finance_nominal_code
    transaction_type { 'income' }
    active { [true, false].sample }
  end
end
