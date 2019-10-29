require "http/client"
require "json"

require "./mappings/*"

module Privacy
  class Client
    PROD_URL    = "https://api.privacy.com/v1"
    SANDBOX_URL = "https://sandbox.privacy.com/v1"

    def initialize(@token : String, @debug_mode : Bool = false)
      if @debug_mode
        @base_url = SANDBOX_URL
      else
        @base_url = PROD_URL
      end
    end

    # TODO: Handle 'rate-limits' and errors
    def request(method : String, path : String, body : String? = nil)
      headers = HTTP::Headers{
        "Authorization" => "api-key #{@token}",
      }

      headers["Content-Type"] = "application/json" if body
      response = HTTP::Client.exec(
        method: method,
        url: @base_url + path,
        headers: headers,
        body: body
      )

      # TODO: Use proper logger
      puts "[OUT]-> #{@base_url}#{path}"
      puts body if body

      response_body = response.body
      puts "[IN]<- #{response_body}"

      response_body
    end

    # List cards of the token
    # [API Docs](https://developer.privacy.com/docs#endpoints-list-cards)
    def cards(
      page : Int32? = nil,
      page_size : Int32? = nil,
      start_date : String? = nil,
      end_date : String? = nil,
      card_token : String? = nil
    )
      query = HTTP::Params.build do |form|
        form.add "page", page if page
        form.add "pagesize", page_size if page_size
        form.add "begin", start_date if start_date
        form.add "end", end_date if end_date
        form.add "card_token", card_token if card_token
      end
      response = request("GET", "/card?#{query}")

      Array(Card).from_json(response, root: "data")
    end

    # List transactions from token
    # [API Docs](https://developer.privacy.com/docs#endpoints-list-transactions)
    def transactions(
      approval_status : ApprovalStatus = ApprovalStatus::ALL,
      page : Int32? = nil,
      page_size : Int32? = nil,
      start_date : String? = nil,
      end_date : String? = nil,
      card_token : String? = nil,
      transaction_token : String? = nil
    )
      query = HTTP::Params.build do |form|
        form.add "page", page if page
        form.add "pagesize", page_size if page_size
        form.add "begin", start_date if start_date
        form.add "end", end_date if end_date
        form.add "card_token", card_token if card_token
        form.add "transaction_token", transaction_token if transaction_token
      end

      # ApprovalStatus will be converted to a string in the concatination
      response = request("GET", "/transaction/#{approval_status.to_s.downcase}?#{query}")
      Array(Transaction).from_json(response, root: "data")
    end

    # This action requires a premium subscription
    # [API Docs](https://developer.privacy.com/docs#endpoints-create-card)
    def create_card(
      name : String? = nil,
      # Limit in -PENNIES-
      spend_limit : Int32? = nil,
      spend_limit_duration : Card::Limit? = nil,
      type : Card::Type = Card::Type::SINGLE_USE
    )
      payload = CreateCardPayload.new(
        type,
        memo: name,
        spend_limit: spend_limit,
        spend_limit_duration: spend_limit_duration
      ).to_json

      response = request("POST", "/card", payload)

      Card.from_json(response)
    end

    # This action requires a premium subscription
    # Note: Setting a card to CLOSED *CANNOT BE UNDONE*
    # [API Docs](https://developer.privacy.com/docs#endpoints-update-card)
    def update_card(
      card_token : String,
      state : Card::State? = nil,
      name : String? = nil,
      spend_limit : Int32? = nil,
      spend_limit_duration : Card::Limit? = nil
    )
      payload = UpdateCardPayload.new(
        card_token,
        memo: name,
        state: state,
        spend_limit: spend_limit,
        spend_limit_duration: spend_limit_duration
      ).to_json

      response = request("PUT", "/card", payload)

      Card.from_json(response)
    end

    # Currently, the 3 below endpoints are in SANDBOX only.

    # Authorization request
    # Returns a json response containing a token to use in void or clear requests.
    # [API Docs](https://developer.privacy.com/docs#endpoints-simulate-authorization)
    def authorize(
      descriptor : String, # Merchant Descriptor
      pan : String,        # 16 Digit Card Number
      amount : Int32       # Amount to authorize in -pennies-
    )
      raise "Authorizing requests can only be done in sandbox mode!" unless @debug_mode

      payload = {
        descriptor: descriptor,
        pan:        pan,
        amount:     amount,
      }.to_json

      response = request("POST", "/simulate/authorize", payload)

      JSON.parse(response)
    end

    # Void a pending authorization
    # Returns error if token is not valid, otherwise
    # returns nothing (in sandbox mode returns debug request id)
    # [API Docs](https://developer.privacy.com/docs#endpoints-simulate-void)
    def void(
      token : String, # Token returned from #authorize
      amount : Int32  # Amount to void in pennies
    )
      raise "Voiding authorizations can only be done in sandbox mode!" unless @debug_mode

      payload = {
        token:  token,
        amount: amount,
      }.to_json

      request("POST", "/simulate/void", payload)
    end

    # Clears an authorization request
    # [API Docs](https://developer.privacy.com/docs#endpoints-simulate-clearing)
    def clear(
      token : String, # Token returned from #authorize
      amount : Int32  # Amount to complete in pennies
    )
      raise "Clearing requests can only be done in sandbox mode!" unless @debug_mode

      payload = {
        token:  token,
        amount: amount,
      }.to_json

      request("POST", "/simulate/clearing", payload)
    end

    # Refunds an amount back to the card
    # Returns a token for the trasaction
    # [API Docs](https://developer.privacy.com/docs#endpoints-simulate-return)
    def return(
      descriptor : String, # Merchant Descriptor
      pan : String,        # 16 Digit Card Number
      amount : Int32       # Amount to return to card in pennies
    )
      raise "Refunding can only be done in sandbox mode!" unless @debug_mode

      payload = {
        descriptor: descriptor,
        pan:        pan,
        amount:     amount,
      }.to_json

      response = request("POST", "/simulate/return", payload)

      JSON.parse(response)
    end
  end
end
