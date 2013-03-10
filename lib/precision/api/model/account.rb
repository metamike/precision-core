module Precision
module API

  class Account

    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: "accounts"

    field :name, type: String
    validates :name, presence: true, uniqueness: true

    field :initial_amount, type: Integer, default: 0
    field :open_date, type: Date
    field :type, type: String

    def id
      _id
    end

    def to_s
      "#{name}"
    end

    # Rename _id to id
    def as_json(options = {})
      super(
        :methods => [:id],
        :except => [:_id]
      )
    end

  end

end
end
