require 'spec_helper'

describe 'Accounts' do

  before(:each) do
    @failure = false
    count = Precision::API::Account.all.length
    if count > 0
      @failure = true
      raise "There are Accounts present.  This does not look like a test database"
    end
    @account_1 = Precision::API::Account.create!({
      name: "Test Account to find",
      initial_amount: 2000,
      open_date: Date.parse('2013-03-01'),
      type: 'Checking'
    })
    @account_2 = Precision::API::Account.create!({
      name: "Test Account to delete"
    })
    @account_3 = Precision::API::Account.create!({
      name: "Test Another Account",
      open_date: Date.parse('2012-11-01')
    })
    @accounts = [@account_1, @account_2, @account_3].sort { |a, b|
      a.name <=> b.name
    }
  end

  context "Find Accounts" do
    it "should find all accounts" do
      get '/accounts'
      last_response.status.should eq 200
      accounts = JSON.parse(last_response.body)
      accounts['data'].size.should eq @accounts.size
      (accounts['data'].map { |a| a['id'] }).should include(
        *@accounts.map { |a| a.id.to_s }
      )
    end
    it "should paginate through accounts" do
      offset = 0
      loop do
        get "/accounts?offset=#{offset}&limit=1"
        last_response.status.should eq 200
        accounts = JSON.parse(last_response.body)
        accounts['data'].size.should eq 1
        (accounts['data'].map { |a| a['id'] }).first.should eq @accounts[offset].id.to_s
        next_chunk = accounts['next']
        break if next_chunk.nil?
        offset = next_chunk[/offset=(\d+)/, 1].to_i
      end
      offset.should eq @accounts.size - 1
    end
    it "should not find a non-existent account" do
      get '/accounts/123'
      last_response.status.should eq 404
    end
    it "should find a valid account" do
      get "/accounts/#{@account_1.id}"
      last_response.status.should eq 200
      hash = JSON.parse(last_response.body)
      hash['name'].should eq @account_1.name
      hash['initial_amount'].should eq @account_1.initial_amount
      hash['open_date'].should eq @account_1.open_date.to_s
      hash['type'].should eq @account_1.type
    end
  end

  context "Create Accounts" do
    it "should not create an un-named account" do
      post "/accounts", {}.to_json
      last_response.status.should eq 422
    end
    it "should create an account" do
      post "/accounts", {name: "Test Create Account 1"}.to_json
      last_response.status.should eq 201
      get "/accounts/#{JSON.parse(last_response.body)['id']}"
      last_response.status.should eq 200
    end
    it "should not create the same account twice" do
      post "/accounts", {name: "Test Create Account 2"}.to_json
      last_response.status.should eq 201
      post "/accounts", {name: "Test Create Account 2"}.to_json
      last_response.status.should eq 422
    end
  end

  context "Delete Accounts" do
    it "should not delete an account" do
      delete "/accounts/123"
      last_response.status.should eq 404
    end
    it "should delete an account" do
      delete "/accounts/#{@account_2.id}"
      last_response.status.should eq 200
      get "/accounts/#{@account_2.id}"
      last_response.status.should eq 404
    end
  end

  after(:each) do
    Precision::API::Account.all.destroy unless @failure
  end
 
end
