class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.references :to_account, index: true, foreign_key: { to_table: :accounts }
      t.references :from_account, index: true, foreign_key: { to_table: :accounts }
      t.decimal :amount

      t.timestamps
    end
  end
end
