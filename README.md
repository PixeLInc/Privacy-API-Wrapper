# EOL

Privacy randomly got rid of their developer api and webhooks a while ago.
I've contacted them about it and they said they are not interested in supporting individuals anymore.

sad.

# A privacy.com API Binding
A binding to the [Privacy API](http://developer.privacy.com) in Crystal.
Provides full coverage of the entire API, including premium and sandboxed endpoints.

## Installation
Add this to your applications `shard.yml`: 
```yaml
dependencies:
  privacy:
    github: pixelinc/privacy-api-wrapper
```

## Usage
###### Any field not explicitly marked as required can be omitted.
###### Some features may require a premium subscription to Privacy, or only work in Sandbox mode.
```crystal
require "privacy"

client = Privacy::Client.new("api-token", true)

# You can optionally supply true/false as another parameter to Client#new
# to enable/disable testing against the sandbox environment (https://sandbox.privacy.com/v1)
# The sandboxed environment has a seperate token that can be located on your profile page.

# Any fields are optional unless specifically stated otherwise.

# Grabs all available cards from your account
client.cards

# Grabs all transactions from your account
client.transactions

# Grabs all funding source from your account
# Takes an optional parameter to specify which type
# Returns `Array(Privacy::FundingAccount)`
client.funding_sources(
  "bank" # This can be "bank", "card", nil, or emitted entirely
)

# You can filter out using the paramaters from the docs
# (https://developer.privacy.com/docs#endpoints-list-cards)
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
# as well as an approval status filter. If no status is supplied, defaults to ALL.
pp client.transactions(Privacy::ApprovalStatus::DECLINES, transaction_token: "3423443-235jb2kb5kb-35jk2b35kb")

# If you have a PREMIUM subscription to privacy, you can create and update cards
# This can also be tested in sandbox mode for free.

client.create_card(
  name: "I am a card name", # An optional card name
  spend_limit: 500, # 5 dollars, in pennies.
  spend_limit_duration: Privacy::Card::Limit::FOREVER, # Allow this card to only spend 5 dollars in its life
  type: Privacy::Card::Type::SINGLE_USE # This field defaults to SINGLE_USE and cannot be nil.
)

# Returns a `Privacy::Card`

client.update_card(
  "13df2278-c8b2-435a-85e4-5fe421eec7ca", # The card token to be updated (REQUIRED)
  state: Privacy::Card::State::CLOSED, # If you set state to CLOSED, this cannot be undone.
  name: "I am a new card name!", # Optionally set a new card name
  spend_limit: 500, # 5 dollars, in pennies.
  spend_limit_duration: Privacy::Card::Limit::FOREVER # 5 dollars throughout it's life.
)

# Returns a `Privacy::Card`

# Add a bank funding source to your account
# NOTE: This requires an ENTERPRISE subscription
client.add_bank(
  123456789, # Routing number
  123456,    # Account number
  "Funding account!" # Optional account name for identification
)

# Returns a `Privacy::FundingAccount`
```

# Sandbox only endpoints
##### There are 4 endpoints that can *only* be used when debugging mode is enabled.
- authorize
- void
- clear
- return

If you enable debug mode (by passing true to the client initializer), you may use the respective functions and parameters as specified in the documentation.
Trying to use sandboxed endpoints without debug mode enabled will raise an exception.

## Contributors

- [PixeL](https://github.com/pixelinc) PixeL - creator, maintainer
