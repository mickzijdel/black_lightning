FactoryBot.define do
  factory :finance_transaction_category, class: 'Finance::TransactionCategory' do
    name { "MyString" }
    hint { "MyText" }
    description { "MyText" }
    nominal_code { "" }
    transaction_type { 1 }
    active { false }
  end
end
