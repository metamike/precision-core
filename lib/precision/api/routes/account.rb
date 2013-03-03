require 'precision/api/model/account'

class Precision::API::Server < Sinatra::Base

  get '/account/:id' do |id|
    content_type :json
    account = Precision::API::Account.find(id)
    unless account.nil?
      account.to_json
    else
      status 404
    end
  end
 
  post '/account' do
    begin
      hash = JSON.parse(request.body.read)
      account = Precision::API::Account.create!(hash)
      status 201
      content_type :json
      {id: account._id}.to_json
    rescue => e
      status 422
      e.message
    end
  end

  delete '/account/:id' do |id|
    account = Precision::API::Account.find(id)
    unless account.nil?
      account.destroy
    else
      status 404
    end
  end

end
