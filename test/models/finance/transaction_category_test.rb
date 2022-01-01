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
require "test_helper"

class Finance::TransactionCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
