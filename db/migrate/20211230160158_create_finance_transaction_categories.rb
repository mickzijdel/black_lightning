class CreateFinanceTransactionCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_transaction_categories do |t|
      t.string :name, null: false
      t.text :hint, null: false
      t.text :description
      t.references :nominal_code, null: false, index: true
      t.integer :transaction_type, null: false, index: true
      t.boolean :active, null: false

      t.timestamps
    end
  end
end
