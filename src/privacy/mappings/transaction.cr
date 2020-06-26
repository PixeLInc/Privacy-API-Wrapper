module Privacy
  struct Transaction
    include JSON::Serializable

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
    getter card : Privacy::Card
    getter created : String

    # A list of all events that have modified this transaction
    # Premium field that requires subscription
    getter events : Array(Privacy::TransactionEvent)

    getter funding : Array(Privacy::FundingAccount)
    getter merchant : Merchant

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Transaction::Result))]
    getter result : Result

    getter settled_amount : Int32

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Transaction::Status))]
    getter status : Status

    getter token : String
  end
end
