class AddReimbursementMethodToExpenditureRequest < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_expenditure_requests do |t|
      t.integer :reimbursement_method, null: false
    end
  end
end
