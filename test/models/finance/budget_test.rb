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
require "test_helper"

class Finance::BudgetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
