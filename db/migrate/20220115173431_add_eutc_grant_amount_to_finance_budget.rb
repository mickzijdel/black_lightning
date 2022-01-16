class AddEutcGrantAmountToFinanceBudget < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_budgets do |t|
      t.monetize :eutc_grant_amount, null: false
    end
  end
end
