require 'date'
require 'model/transaction'

class Precision::API::Server < Sinatra::Base

  # {
  #   from_account,
  #   to_account,
  #   description,
  #   date,
  #   amount
  # }
  # TODO This operation should be atomic or at least isolated
  post '/transfer' do
    begin
      hash = JSON.parse(request.body.read)
      raise "from_account is required" if hash['from_account'].nil?
      from_account = Precision::API::Account.where(name: hash['from_account']).first
      raise "No such account: #{hash['from_account']}" if account.nil?
      raise "to_account is required" if hash['to_account'].nil?
      to_account = Precision::API::Account.where(name: hash['to_account']).first
      raise "No such account: #{hash['to_account']}" if account.nil?

      # A transfer is two transactions: a credit and a debit
      debit = Precision::API::Transaction.create!({
        description: "Transfer from #{from_account.name} to #{to_account.name}",
        amount: -(hash['amount'].to_i),
        date: Date.parse(hash['date']),
        account: from_account,
        tags: ['transfers']
      })
      credit = Precision::API::Transaction.create!({
        description: "Transfer from #{from_account.name} to #{to_account.name}",
        amount: hash['amount'].to_i,
        date: Date.parse(hash['date']),
        account: to_account,
        tags: ['transfers']
      })
      status 201
      content_type :json
      {debit_id: debit._id, credit_id: credit._id}.to_json
    rescue => e
      status 422
      e.message
    end
  end

end
