class AddIsDraftBooleanToFinanceBudget < ActiveRecord::Migration[6.1]
  def change
    change_table :finance_budgets do |t|
      t.boolean :is_draft, null: false
    end
  end
end
