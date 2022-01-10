# == Schema Information
#
# Table name: finance_bank_informations
#
# *id*::                  <tt>bigint, not null, primary key</tt>
# *account_holder_name*:: <tt>string(255), not null</tt>
# *sort_code*::           <tt>string(255), not null</tt>
# *account_number*::      <tt>string(255), not null</tt>
# *user_id*::             <tt>integer</tt>
# *created_at*::          <tt>datetime, not null</tt>
# *updated_at*::          <tt>datetime, not null</tt>
#--
# == Schema Information End
#++
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
