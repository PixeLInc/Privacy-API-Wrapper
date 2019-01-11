require "http/client"
require "json"

require "./privacy/mappings/*"

module Privacy
  class Client
    BASE_URL = "https://api.privacy.com/v1"

    def initialize(@token : String)
    end

    # TODO: Handle 'rate-limits' and errors
    # TODO: Handle Create(POST)/Update(PUT) card endpoints when released
    def request(path)
      response = HTTP::Client.get(
        "#{BASE_URL}#{path}",
        HTTP::Headers{
          "Authorization" => @token,
        }
      )

      response.body
    end

    def cards(page : Int32? = nil, page_size : Int32? = nil, start_date : String? = nil, end_date : String? = nil, card_token : String? = nil)
      query = HTTP::Params.build do |form|
        form.add "page", page if page
        form.add "pagesize", page_size if page_size
        form.add "begin", start_date if start_date
        form.add "end", end_date if end_date
        form.add "cardtoken", card_token if card_token
      end
      response = request("/card?#{query}")

      Array(Types::Card).from_json(response, root: "data")
    end

    def transactions(page : Int32? = nil, page_size : Int32? = nil, start_date : String? = nil, end_date : String? = nil, card_token : String? = nil, transaction_token : String? = nil)
      query = HTTP::Params.build do |form|
        form.add "page", page if page
        form.add "pagesize", page_size if page_size
        form.add "begin", start_date if start_date
        form.add "end", end_date if end_date
        form.add "cardtoken", card_token if card_token
        form.add "transactiontoken", transaction_token if transaction_token
      end

      response = request("/transaction?#{query}")

      Array(Types::Transaction).from_json(response, root: "data")
    end
  end
end
