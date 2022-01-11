class AddTransactionCategoryAndExpenseDateToExpenditureRequest < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_expenditure_requests do |t|
      t.date :expense_date, null: false
      t.references :transaction_category, null: false, foreign_key: { to_table: :finance_transaction_categories }, index: { name: :index_expenditure_requests_on_transaction_category_id }
    end
  end
end
