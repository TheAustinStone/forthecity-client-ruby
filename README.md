# Restore Strategies' Ruby gem

This is a Ruby gem for the Restore Strategies API. The gem allows clients to view, filter, search & sign up for volunteer opportunities.

## Initialize

To use the API you need valid credentials. The client requires a valid token & secret.

```ruby
require 'restore_strategies'

RestoreStrategies::Client.new('<a_user_token>', '<a_user_secret>')
```

## Viewing & Searching Opportunities

This works similar to ActiveRecord. The methods ```find```, ```first```, ```all```, & ```where``` are available.


```ruby
# Finds a specific opportunity based on id
RestoreStrategies::Opportunity.find(1)

# Returns all opportunities
RestoreStrategies::Opportunity.all

# Returns the first opportunity
RestoreStrategies::Opportunity.first

# Returns opportunities within the 'Education' or 'Children/Youth' issues & the 
# 'South' or 'Central' regions that have the key words 'foster care'
RestoreStrategies::Opportunity.where(
  q: 'foster care',
  issues: ['Education', 'Children/Youth'],
  region: ['South', 'Central']
)
```

## Signup

Signups can be submitted for opportunities. In the below example, each of the keys are required

```ruby

signup = RestoreStrategies::Signup.new({
  given_name: 'Jon',
  family_name: 'Doe',
  email: 'jon.doe@example.com',
  telephone: '5127088860',
  opportunity_id: 37
})

puts "The signup is valid, true or false? #{signup.valid?}"

if signup.save
  puts 'You signed up!'
end
```


