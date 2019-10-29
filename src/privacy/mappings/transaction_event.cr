module Privacy
  struct TransactionEvent
    include JSON::Serializable

    enum Type
      AUTHORIZATION
      AUTHORIZATION_ADVICE
      CLEARING
      VOID
      RETURN
    end

    getter amount : Int32
    getter created : String
    getter token : String

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::Transaction::Result))]
    getter result : Privacy::Transaction::Result

    @[JSON::Field(converter: Privacy::EnumParser(Privacy::TransactionEvent::Type))]
    getter type : Type
  end
end
