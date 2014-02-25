# encoding: utf-8
require 'spec_helper'

describe SEPA::DirectDebit do
  it 'should create valid XML file' do
    dd = SEPA::DirectDebit.new :name       => 'Gläubiger GmbH',
                               :bic        => 'BANKDEFFXXX',
                               :iban       => 'DE87200500001234567890',
                               :identifier => 'DE98ZZZ09999999999'

    dd.add_transaction :name                      => 'Zahlemann & Söhne GbR',
                       :bic                       => 'SPUEDE2UXXX',
                       :iban                      => 'DE21500500009876543210',
                       :amount                    => 39.99,
                       :reference                 => 'XYZ/2013-08-ABO/12345',
                       :remittance_information    => 'Unsere Rechnung vom 10.08.2013',
                       :mandate_id                => 'K-02-2011-12345',
                       :mandate_date_of_signature => Date.new(2011,1,25),
                       :sequence_type             => 'OOFF'

    dd.add_transaction :name                      => 'Meier & Schulze oHG',
                       :bic                       => 'GENODEF1JEV',
                       :iban                      => 'DE68210501700012345678',
                       :amount                    => 750.00,
                       :reference                 => 'XYZ/2013-08-ABO/6789',
                       :remittance_information    => 'Vielen Dank für Ihren Einkauf!',
                       :mandate_id                => 'K-08-2010-42123',
                       :mandate_date_of_signature => Date.new(2010,7,25),
                       :sequence_type             => 'FRST'

    XML::Document.string(dd.to_xml).should validate_against('pain.008.002.02.xsd')
  end
end
