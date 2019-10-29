module Privacy
  struct FundingAccount
    include JSON::Serializable

    enum Type
      DEPOSITORY_CHECKING
      DEPOSITORY_SAVINGS
      CARD_DEBIT
    end

    getter account_name : String?
    getter token : String

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::FundingAccount::Type))]
    getter type : Type
  end
end
