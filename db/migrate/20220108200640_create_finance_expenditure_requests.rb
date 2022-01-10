class CreateFinanceExpenditureRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_expenditure_requests do |t|
      t.string :name, null: false
      t.text :submitter_notes
      t.text :business_manager_notes
      
      t.monetize :amount, null: false

      t.references :budget_line, null: false, foreign_key: { to_table: :finance_budget_lines }, index: true
      t.integer :user_id, null: false, foreign_key: true, index: true
      t.references :bank_information, foreign_key: { to_table: :finance_bank_informations }, index: { name: :index_expenditure_requests_on_bank_information_id }

      t.integer :request_status, index: true
      t.integer :proof_status, null: false, index: true

      t.timestamps
    end
  end
end
