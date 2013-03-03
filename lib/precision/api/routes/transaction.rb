require 'precision/api/model/transaction'

class Precision::API::Server < Sinatra::Base

  get '/transaction/:id' do |id|
    content_type :json
    transaction = Precision::API::Transaction.find(id)
    unless transaction.nil?
      transaction.to_json
    else
      status 404
    end
  end
 
  post '/transaction' do
    begin
      hash = JSON.parse(request.body.read)
      raise "account is required" if hash['account'].nil?
      account = Precision::API::Account.where(name: hash['account']).first
      raise "No such account: #{hash['account']}" if account.nil?
      hash.delete('account')
      transaction = Precision::API::Transaction.new(hash)
      transaction.account = account
      transaction.save!
      status 201
      content_type :json
      {id: transaction._id}.to_json
    rescue => e
      status 422
      e.message
    end
  end

  delete '/transaction/:id' do |id|
    transaction = Precision::API::Transaction.find(id)
    unless transaction.nil?
      transaction.destroy
    else
      status 404
    end
  end

end
