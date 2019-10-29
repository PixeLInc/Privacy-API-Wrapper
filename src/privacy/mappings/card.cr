module Privacy
  struct Card
    include JSON::Serializable

    enum Type
      SINGLE_USE
      MERCHANT_LOCKED

      # UNLOCKED and PHYSICAL require a premium subscription
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

    getter funding : Privacy::FundingAccount
    getter hostname : String
    getter last_four : String
    getter memo : String
    getter pan : String
    getter spend_limit : Int32
    getter token : String

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Limit))]
    getter spend_limit_duration : Limit

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::State))]
    getter state : State

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Type))]
    getter type : Type

    # The following require a Privacy PREMIUM Subscription to use.
    getter cvv : String
    getter exp_month : String
    getter exp_year : String
  end
end
