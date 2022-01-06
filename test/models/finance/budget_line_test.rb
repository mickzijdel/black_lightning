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
require "test_helper"

class Finance::BudgetLineTest < ActiveSupport::TestCase
  test 'cannot have income with negative allocation' do
    budget_line = finance_budget_lines(:income_budget_line)

    assert_raise ActiveRecord::RecordInvalid do
      budget_line.allocated = -10
      budget_line.save!
    end
  end

  test 'cannot have expense with positive allocation' do
    budget_line = finance_budget_lines(:expense_budget_line)

    assert_raise ActiveRecord::RecordInvalid do
      budget_line.allocated = 10
      budget_line.save!
    end
  end
end
