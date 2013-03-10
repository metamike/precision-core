require 'spec_helper'

describe 'Transactions' do

  before(:each) do
    @failure = false
    count = Precision::API::Account.all.length
    if count > 0
      @failure = true
      raise "There are accounts present.  This does not look like a test database"
    end
    @account_1 = Precision::API::Account.create!({
      name: "Test Account to find",
      initial_amount: 2000,
      open_date: Date.parse('2013-03-01'),
      type: 'Checking'
    })
    @tx_1 = Precision::API::Transaction.create!({
      description: "Test TX 1",
      date: Date.parse('2013-03-04'),
      amount: -500,
      tags: ['tag1', 'tag2'],
      account: @account_1
    })
    @tx_2 = Precision::API::Transaction.create!({
      description: "Test TX 2",
      date: Date.parse('2013-03-09'),
      amount: -1600,
      tags: ['tag2', 'tag3', 'tag4'],
      account: @account_1
    })
    @txs = [@tx_1, @tx_2].sort { |a, b|
      if (a.date <=> b.date) != 0
        a.date <=> b.date
      else
        if (a.description <=> b.description) != 0
          a.description <=> b.description
        else
          a._id <=> b._id
        end
      end
    }
  end

  context "Find Transactions" do
    it "should find all transactions" do
      get '/transactions'
      last_response.status.should eq 200
      txs = JSON.parse(last_response.body)
      txs['data'].size.should eq @txs.size
      (txs['data'].map { |a| a['id'] }).should include(
        *@txs.map { |a| a.id.to_s }
      )
      txs['next'].should be_nil
    end
    it "should paginate through transactions" do
      offset = 0
      loop do
        get "/transactions?offset=#{offset}&limit=1"
        last_response.status.should eq 200
        txs = JSON.parse(last_response.body)
        txs['data'].size.should eq 1
        (txs['data'].map { |a| a['id'] }).first.should eq @txs[offset].id.to_s
        next_chunk = txs['next']
        break if next_chunk.nil?
        offset = next_chunk[/offset=(\d+)/, 1].to_i
      end
      offset.should eq @txs.size - 1
    end
    it "should not find a non-existent transaction" do
      get '/transactions/123'
      last_response.status.should eq 404
    end
    it "should find a valid transaction" do
      get "/transactions/#{@tx_1.id}"
      last_response.status.should eq 200
      hash = JSON.parse(last_response.body)
      hash['description'].should eq @tx_1.description
      hash['amount'].should eq @tx_1.amount
      hash['date'].should eq @tx_1.date.to_s
      hash['tags'].sort.should eq @tx_1.tags.sort
      hash['account']['id'].should eq @account_1.id.to_s
    end
  end

  context "Create transactions" do
    it "should not create an un-described transaction" do
      post "/transactions", {}.to_json
      last_response.status.should eq 422
    end
    it "should not create a transaction with an unknown account" do
      post "/transactions", {
        description: "Test unknown account TX",
        amount: 11850,
        date: Date.parse('2013-04-25'),
        account: '12345',
        tags: ['atag', 'btag']
      }.to_json
      last_response.status.should eq 422
    end
    it "should create a transaction" do
      post "/transactions", {
        description: "Test Create TX 1",
        amount: 850,
        date: Date.parse('2013-02-15'),
        account: 'Test Account to find',
        tags: ['atag']
      }.to_json
      last_response.status.should eq 201
      get "/transactions/#{JSON.parse(last_response.body)['id']}"
      last_response.status.should eq 200
    end
  end

  context "Delete transactions" do
    it "should not delete a transaction" do
      delete "/transactions/123"
      last_response.status.should eq 404
    end
    it "should delete a transaction" do
      delete "/transactions/#{@tx_2.id}"
      last_response.status.should eq 200
      get "/transactions/#{@tx_2.id}"
      last_response.status.should eq 404
    end
  end

  after(:each) do
    Precision::API::Transaction.all.destroy unless @failure
    Precision::API::Account.all.destroy unless @failure
  end
 
end
