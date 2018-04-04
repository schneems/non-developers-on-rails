json.extract! transaction, :id, :from_account_id, :to_account_id, :amount, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
