require 'spec_helper'

describe 'Accounts' do

  before(:all) do
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
  end

  context "Find Accounts" do
    it "should find all accounts" do
      get '/accounts'
      last_response.status.should eq 200
      accounts = JSON.parse(last_response.body)
      accounts.length.should be >= 1
      (accounts.map { |a| a['_id'] }).should include(@account_1._id.to_s)
    end
    it "should not find a non-existent account" do
      get '/accounts/123'
      last_response.status.should eq 404
    end
    it "should find a valid account" do
      get "/accounts/#{@account_1._id}"
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
      delete "/accounts/#{@account_2._id}"
      last_response.status.should eq 200
      get "/accounts/#{@account_2._id}"
      last_response.status.should eq 404
    end
  end

  after(:all) do
    Precision::API::Account.all.destroy unless @failure
  end
 
end
