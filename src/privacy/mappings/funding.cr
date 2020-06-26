module Privacy
  struct FundingAccount
    include JSON::Serializable

    enum Type
      DEPOSITORY_CHECKING
      DEPOSITORY_SAVINGS
      CARD_DEBIT
    end

    enum State
      ENABLED
      PENDING
    end

    getter account_name : String?
    getter created : String?
    getter nickname : String?
    getter last_four : String?
    getter token : String

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::FundingAccount::State))]
    getter state : State

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::FundingAccount::Type))]
    getter type : Type
  end
end
