module Precision
module API

  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps
    store_in collection: "transactions"

    field :description, type: String
    validates :description, presence: true

    field :date, type: Date
    validates :date, presence: true

    field :amount, type: Integer
    validates :amount, presence: true

    field :tags, type: Array
    validates :tags, presence: true

    embeds_one :account
    validates :account, presence: true

    index({tags: 1})

    scope :by_tag, ->(tag) { where(:tags.in => [tag]) }
  end

end
end
