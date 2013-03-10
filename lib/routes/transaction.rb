require 'model/account'
require 'model/transaction'

class Precision::API::Server < Sinatra::Base

  get '/transactions' do
    offset = params.has_key?('offset') ? params['offset'].to_i : 0
    limit = params.has_key?('limit') ? params['limit'].to_i : 50
    txs = Precision::API::Transaction.skip(offset).limit(limit + 1).to_a
    num_txs_plus1 = txs.size
    txs.pop if num_txs_plus1 == limit + 1

    content_type :json
    {
      data: txs,
      :next => num_txs_plus1 > limit ? "#{request.scheme}://#{request.host}:#{request.port}#{request.path}?offset=#{offset + limit}&limit=#{limit}" : nil
    }.to_json
  end

  get '/transactions/:id' do |id|
    content_type :json
    transaction = Precision::API::Transaction.find(id)
    unless transaction.nil?
      transaction.to_json
    else
      status 404
    end
  end
 
  post '/transactions' do
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
      {id: transaction.id}.to_json
    rescue => e
      status 422
      e.message
    end
  end

  delete '/transactions/:id' do |id|
    transaction = Precision::API::Transaction.find(id)
    unless transaction.nil?
      transaction.destroy
    else
      status 404
    end
  end

end
