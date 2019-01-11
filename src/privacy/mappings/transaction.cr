module Privacy
  struct Transaction
    include JSON::Serializable

    struct Funding
      include JSON::Serializable

      getter amount : Int32
      getter token : String
      getter type : String
    end

    enum Status
      PENDING
      VOIDED
      SETTLING
      SETTLED
      BOUNCED
    end

    enum Result
      APPROVED
      CARD_PAUSED
      CARD_CLOSED
      GLOBAL_TRANSACTION_LIMIT
      GLOBAL_WEEKLY_LIMIT
      GLOBAL_MONTHLY_LIMIT
      USER_TRANSACTION_LIMIT
      UNAUTHORIZED_MERCHANT
      SINGLE_USE_RECHARGED
      BANK_CONNECTION_ERROR
      INSUFFICIENT_FUNDS
      MERCHANT_BLACKLIST
      INVALID_CARD_DETAILS
      BANK_NOT_VERIFIED
      INACTIVE_ACCOUNT
      UNKNOWN_HOST_TIMEOUT
      SWITCH_INOPERATIVE_ADVICE
      FRAUD_ADVICE
    end

    getter amount : Int32
    getter card : Types::Card
    getter created : String

    # No docs on this
    getter events : Array(String)

    # An array of funding for some reason.
    getter funding : Array(Funding)
    getter merchant : Merchant

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Transaction::Result))]
    getter result : Result

    getter settled_amount : Int32

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Transaction::Status))]
    getter status : Status

    getter token : String
  end
end
