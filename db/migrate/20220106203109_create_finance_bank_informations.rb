class CreateFinanceBankInformations < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_bank_informations do |t|
      t.string :account_holder_name, null: false
      t.string :sort_code, null: false
      t.string :account_number, null: false
      t.integer :user_id, foreign_key: true, index: true

      t.timestamps
    end
  end
end
