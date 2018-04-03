class Transaction < ApplicationRecord
  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"

  after_commit :transfer_the_dough

  def transfer_the_dough
    from_account.balance = from_account.balance - amount
    to_account.balance = to_account.balance + amount
    from_account.save!
    to_account.save!
  end
end
