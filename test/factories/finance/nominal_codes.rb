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
FactoryBot.define do
  factory :nominal_code, class: 'Finance::NominalCode' do
    code        { Faker::Number.number(digits: 6) }
    name        { generate(:random_name) }
    hint        { generate(:random_text)   }
    description { generate(:random_text)   }
    active      { [true, false].sample      }
  end
end
