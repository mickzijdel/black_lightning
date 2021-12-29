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
require "test_helper"

class Finance::NominalCodeTest < ActiveSupport::TestCase
  test 'code, name, description and active must be present' do
    assert_raises ActiveRecord::RecordInvalid do
      Finance::NominalCode.create!({})
    end
  end

  test 'nominal_code code must follow restrictions' do
    params = {
      name: 'Test Code',
      description: 'Nonsense',
      active: true
    }

    # Must not be lower than 6.
    assert_raises ActiveRecord::RecordInvalid do
      Finance::NominalCode.create!([params, { code: '50000' }])
    end
    # Must not be 6
    assert_raises ActiveRecord::RecordInvalid do
      Finance::NominalCode.create!([params, { code: '-7000000' }])
    end

    # Must not be duplicate.
    assert_raises ActiveRecord::RecordInvalid do
      Finance::NominalCode.create!([params, { code: finance_nominal_codes(:sundry).code }])
    end

    # Must be present
    assert_raises ActiveRecord::RecordInvalid do
      Finance::NominalCode.create!(params)
    end

    # Valid one
    Finance::NominalCode.create([params, { code: '600000' }])
  end

  test 'default_scope excludes inactive codes' do
    assert_includes Finance::NominalCode.all, finance_nominal_codes(:sundry)
    assert_not_includes Finance::NominalCode.all, finance_nominal_codes(:inactive)
  end
end
