FactoryBot.define do
  factory :finance_bank_information, class: 'Finance::BankInformation' do
    account_holder_name { generate(:random_name) }

    transient do
      details_index { (0..9).sample }
    end

    # These might become invalid in future versions of the gem, so be aware of this when a bank informations test starts to sometimes fail for no discernablereason.
    sort_code { %w[185008 826632 400515 309493 600920 070116 830402 090126 609104 080054][details_index] }
    account_number { %w[12098709 20400952 12345674 01273801 67037135 10909132 10126939 03367219 17068859 70328725][details_index] }
  end
end
