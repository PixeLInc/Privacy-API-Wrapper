module Privacy
  struct Merchant
    include JSON::Serializable

    getter acceptor_id : String
    getter city : String
    getter country : String
    getter descriptor : String
    getter mcc : String
    getter state : String
  end
end
