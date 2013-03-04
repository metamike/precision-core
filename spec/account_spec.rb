require 'spec_helper'

describe 'Accounts' do

  before(:all) do
    @failure = false
    count = Precision::API::Account.all.length
    if count > 2
      @failure = true
      raise "There are #{count} Accounts.  This does not look like a test database"
    end
    @account_1 = Precision::API::Account.create!({
      name: "Test Account 1"
    })
    @account_2 = Precision::API::Account.create!({
      name: "Test Account 2"
    })
  end

  context "Find Accounts" do
    it "should not find an account" do
      get '/account/123'
      last_response.status.should eq 404
    end
    it "should find an account" do
      get "/account/#{@account_1._id}"
      last_response.status.should eq 200
    end
  end

  context "Create Accounts" do
    it "should not create an un-named account" do
      post "/account", {}.to_json
      last_response.status.should eq 422
    end
    it "should create an account" do
      post "/account", {name: "Test Create Account 1"}.to_json
      last_response.status.should eq 201
      get "/account/#{JSON.parse(last_response.body)['id']}"
      last_response.status.should eq 200
    end
    it "should not create the same account twice" do
      post "/account", {name: "Test Create Account 2"}.to_json
      last_response.status.should eq 201
      post "/account", {name: "Test Create Account 2"}.to_json
      last_response.status.should eq 422
    end
  end

  context "Delete Accounts" do
    it "should not delete an account" do
      delete "/account/123"
      last_response.status.should eq 404
    end
    it "should delete an account" do
      delete "/account/#{@account_2._id}"
      last_response.status.should eq 200
      get "/account/#{@account_2._id}"
      last_response.status.should eq 404
    end
  end

  after(:all) do
    Precision::API::Account.all.destroy unless @failure
  end
 
end
