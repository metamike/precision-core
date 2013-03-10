require 'precision/api/model/account'

class Precision::API::Server < Sinatra::Base

  get '/accounts' do
    offset = params.has_key?('offset') ? params['offset'].to_i : 0
    limit = params.has_key?('limit') ? params['limit'].to_i : 50
    content_type :json
    accounts = Precision::API::Account.skip(offset).limit(limit + 1).to_a
    num_accounts_plus1 = accounts.size
    accounts.pop if num_accounts_plus1 == limit + 1
    {
      data: accounts,
      :next => num_accounts_plus1 > limit ? "#{request.scheme}://#{request.host}:#{request.port}#{request.path}?offset=#{offset + limit}&limit=#{limit}" : nil
    }.to_json
  end

  get '/accounts/:id' do |id|
    content_type :json
    account = Precision::API::Account.find(id)
    unless account.nil?
      account.to_json
    else
      status 404
    end
  end
 
  post '/accounts' do
    begin
      hash = JSON.parse(request.body.read)
      account = Precision::API::Account.create!(hash)
      status 201
      content_type :json
      {id: account.id}.to_json
    rescue => e
      status 422
      e.message
    end
  end

  delete '/accounts/:id' do |id|
    account = Precision::API::Account.find(id)
    unless account.nil?
      account.destroy
    else
      status 404
    end
  end

end
