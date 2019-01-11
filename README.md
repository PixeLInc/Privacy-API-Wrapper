# A privacy.com API Binding
A binding to the [Privacy API](http://developer.privacy.com) in Crystal.

##### This binding *does not* support Create Card and Update Card endpoints as they are in early access.

## Installation
Add this to your applications `shard.yml`: 
```yaml
dependencies:
  privacy:
    github: pixelinc/privacy-api-wrapper
```

## Usage
```crystal
require "privacy"

client = Privacy::Client.new("api-key <api-token>")

# Grabs all available cards from your account
client.cards

# Grabs all transactions from your account
client.transactions

# You can filter out using the paramaters from the docs
client.cards(
  page: 1 # Search the first page for a list of cards
  page_size: 50 # Max elements per page
  start_date: "YYYY-MM-DD" # Earliest date to show cards from
  end_date: "YYYY-MM-DD" # Latest date to show cards from
  card_token: "TOKEN" # Show only a certain card via its token
)

# Example usage
pp client.cards(card_token: "345nkjsdkf-45kjw3jk5a-a3k5jbk35")

# Transaction contains the same parameters as cards but,
# you have an additional transaction_token that is available to you 
pp client.transactions(transaction_token: "3423443-235jb2kb5kb-35jk2b35kb")
```

## Contributors

- [PixeL](https://github.com/pixelinc) PixeL - creator, maintainer

