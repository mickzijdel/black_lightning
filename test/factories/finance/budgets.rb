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
FactoryBot.define do
  factory :finance_budget, class: 'Finance::Budget' do
    title { generate(:random_name) }
    description { generate(:random_text) }

    budget_category { [0, 1, 2].sample }
    status { [0, 1, 2].sample }

    is_draft { [true, false].sample }

    eutc_grant_amount_cents { rand(25000) }
    association :event, factory: :show
  end
end
