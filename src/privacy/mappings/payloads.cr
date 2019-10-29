module Privacy
  struct UpdateCardPayload
    include JSON::Serializable

    getter card_token : String
    getter memo : String?
    getter spend_limit : Int32?

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::State))]
    getter state : Privacy::Card::State?

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Limit))]
    getter spend_limit_duration : Privacy::Card::Limit?

    def initialize(@card_token, @memo = nil, @state = nil, @spend_limit = nil, @spend_limit_duration = nil)
    end
  end

  struct CreateCardPayload
    include JSON::Serializable

    getter memo : String?
    getter spend_limit : Int32?

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Limit))]
    getter spend_limit_duration : Privacy::Card::Limit?

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Card::Type))]
    getter type : Privacy::Card::Type

    def initialize(@type, @memo = nil, @spend_limit = nil, @spend_limit_duration = nil)
    end
  end
end
