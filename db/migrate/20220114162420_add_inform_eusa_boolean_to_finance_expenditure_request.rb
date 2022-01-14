class AddInformEusaBooleanToFinanceExpenditureRequest < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_expenditure_requests do |t|
      t.boolean :inform_eusa
    end
  end
end
