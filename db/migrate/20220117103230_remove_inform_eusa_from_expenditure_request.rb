class RemoveInformEusaFromExpenditureRequest < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_expenditure_requests do |t|
      t.remove :inform_eusa

      t.date :processed_date
    end
  end
end
