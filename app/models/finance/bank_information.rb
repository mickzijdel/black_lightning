class Finance::BankInformation < ApplicationRecord
  belongs_to :user, optional: true

  validates :account_holder_name, :sort_code, :account_number, presence: true
  validates :sort_code, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }, length: { is: 6 }
  validates :account_number, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }, length: { in: 6..8 }

  validate :modulus_check

  def label
    account_holder_name
  end

  # Verify if the account_number and sort_code pass the modulus check.
  def modulus_check
    return if UkAccountValidator::Validator.new(account_number, sort_code).valid?

    # Here is more information on the gem: https://github.com/ball-hayden/uk_account_validator
    # If this error happens with a 100% correct account number and sort code, you might need
    # to submit a pull request to this gem to update the verification tables.
    errors.add(:account_number, 'This combination of account number and sort code is invalid. Please double-check the entered values, and check with the Business Manager if there if the issue persists.')
  end
end
