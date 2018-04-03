class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :from_account, foreign_key: true
      t.references :to_account, foreign_key: true

      t.references :from_account, index: true, foreign_key: { to_table: :accounts }
      t.references :fromz, index: true, foreign_key: { to_table: :accounts }

      t.decimal :amount

      t.timestamps
    end
  end
end
