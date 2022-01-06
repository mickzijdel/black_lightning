module TransactionType
  extend ActiveSupport::Concern

  # When editing this be very very careful to replace all references to both id and key.
  TRANSACTION_TYPES = { 'Expense' => 0, 'Income' => 1 }.freeze

  included do
    enum transaction_type: TRANSACTION_TYPES
  end
end
