module Privacy
  struct Card
    include JSON::Serializable

    enum Type
      SINGLE_USE
      MERCHANT_LOCKED
      UNLOCKED
      PHYSICAL
    end

    enum State
      OPEN
      PAUSED
      CLOSED
    end

    enum Limit
      TRANSACTION
      MONTHLY
      ANUALLY
      FOREVER
    end

    struct Funding
      include JSON::Serializable

      getter account_name : String
      getter token : String

      # I don't know what the types are other than 'DEPOSITORY_CHECKING'
      getter type : String
    end

    getter funding : Funding
    getter hostname : String
    getter last_four : String
    getter memo : String
    getter spend_limit : Int32
    getter token : String

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Limit))]
    getter spend_limit_duration : Limit

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::State))]
    getter state : State

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Type))]
    getter type : Type
  end
end
