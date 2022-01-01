class CreateFinanceBudgets < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_budgets do |t|
      t.string :title, null: false
      t.text :notes
      t.references :event, index: true
      t.integer :budget_category, null: false, index: true
      t.integer :status, null: false, index: true

      t.timestamps
    end
  end
end
