class CreateFinanceBudgetLines < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_budget_lines do |t|
      t.string :name, null: false
      t.monetize :allocated, null: false, currency: { present: false }
      t.integer :transaction_type, null: false, index: true
      t.references :budget, null: false, index: true

      t.timestamps
    end
  end
end
