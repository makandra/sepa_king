# SEPA King (*Ruby 1.8.7 backport*)

### About this fork

This is a fork which backports [`sepa_king`](https://github.com/salesking/sepa_king) to work on Ruby 1.8.7.

Backport by [Ruby Backports](http://rubybackports.com).

### Features

* Credit transfer (pain.001.002.03)
* Debit transfer (pain.008.002.02)
* Tested with Ruby 1.8.7

### Installation

Include this git source in your `Gemfile`:

    gem 'sepa_king', :git => 'https://github.com/makandra/sepa_king.git', :branch => 'ruby_1_8_7'

### Examples

How to create a SEPA file for direct debit ("Lastschrift")

```ruby
# First: Create the main object
dd = SEPA::DirectDebit.new :name       => 'Gläubiger GmbH',
                           :bic        => 'BANKDEFFXXX',
                           :iban       => 'DE87200500001234567890',
                           :identifier => 'DE98ZZZ09999999999'

# Second: Add transactions
dd.add_transaction :name                      => 'Zahlemann & Söhne GbR',
                   :bic                       => 'SPUEDE2UXXX',
                   :iban                      => 'DE21500500009876543210',
                   :amount                    => 39.99,
                   :reference                 => 'XYZ/2013-08-ABO/6789',
                   :remittance_information    => 'Vielen Dank für Ihren Einkauf!',
                   :mandate_id                => 'K-02-2011-12345',
                   :mandate_date_of_signature => Date.new(2011,1,25),
                   :sequence_type             => 'OOFF' # 'OOFF', 'FRST', 'RCUR', 'FNAL'

dd.add_transaction ...

# Last: create XML string
xml_string = dd.to_xml
```


How to create a SEPA file for credit transfer ("Überweisung")

```ruby
# First: Create the main object
ct = SEPA::CreditTransfer.new :name       => 'Schuldner GmbH',
                              :bic        => 'BANKDEFFXXX',
                              :iban       => 'DE87200500001234567890'

# Second: Add transactions
ct.add_transaction :name                   => 'Telekomiker AG',
                   :bic                    => 'PBNKDEFF370',
                   :iban                   => 'DE37112589611964645802',
                   :amount                 => 102.50,
                   :reference              => 'XYZ-1234/123',
                   :remittance_information => 'Rechnung vom 22.08.2013'
ct.add_transaction ...

# Last: create XML string
xml_string = ct.to_xml
```

Make sure to read the code and the specs!


### License

Released under the MIT license

### Credits

* [Original code](https://github.com/salesking/sepa_king) by Georg Leciejewski and Georg Ledermann at SalesKing
* This fork has been backported to support Ruby 1.8.7 by [makandra](http://www.makandra.com/) / [Ruby Backports](http://rubybackports.com/)
