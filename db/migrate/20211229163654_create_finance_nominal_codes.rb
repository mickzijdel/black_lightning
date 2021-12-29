class CreateFinanceNominalCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :finance_nominal_codes do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.text :description, null: false
      t.boolean :active, null: false

      t.timestamps
    end
  end
end
