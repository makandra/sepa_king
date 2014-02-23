# encoding: utf-8
require 'spec_helper'

describe SEPA::DebtTransaction do
  it 'should initialize a new transaction' do
    lambda{
      SEPA::DebtTransaction.new :name                      => 'Zahlemann & Söhne Gbr',
                                :bic                       => 'SPUEDE2UXXX',
                                :iban                      => 'DE21500500009876543210',
                                :amount                    => 39.99,
                                :reference                 => 'XYZ-1234/123',
                                :remittance_information    => 'Vielen Dank für Ihren Einkauf!',
                                :mandate_id                => 'K-02-2011-12345',
                                :mandate_date_of_signature => Date.new(2011,1,25),
                                :sequence_type             => 'FRST'
    }.should_not raise_error
  end

  context 'Mandate Date of Signature' do
    it 'should allow valid value' do
      [ Date.today, Date.today - 1 ].each do |valid_value|
        lambda {
          SEPA::DebtTransaction.new :mandate_date_of_signature => valid_value
        }.should_not raise_error
      end
    end

    it 'should not allow invalid value' do
      [ nil, '2010-12-01', Date.today + 1 ].each do |invalid_value|
        lambda {
          SEPA::DebtTransaction.new :mandate_date_of_signature => invalid_value
        }.should raise_error(ArgumentError, /Signature/)
      end
    end
  end

  context 'Mandate ID' do
    it 'should allow valid value' do
      [ 'XYZ-123', 'X' * 35 ].each do |valid_value|
        lambda {
          SEPA::DebtTransaction.new :mandate_id => valid_value
        }.should_not raise_error
      end
    end

    it 'should not allow invalid value' do
      [ nil, '', 'X' * 36 ].each do |invalid_value|
        lambda {
          SEPA::DebtTransaction.new :mandate_id => invalid_value
        }.should raise_error(ArgumentError, /Mandate ID/)
      end
    end
  end

  context 'Sequence Type' do
    it 'return OOFF as default' do
      transaction = SEPA::DebtTransaction.new :name => 'Zahlemann & Söhne Gbr'
      transaction.sequence_type.should == 'OOFF'
    end

    it 'should allow valid value' do
      %w(FRST OOFF RCUR FNAL).each do |valid_value|
        lambda {
          SEPA::DebtTransaction.new :sequence_type => valid_value
        }.should_not raise_error
      end
    end

    it 'should not allow invalid value' do
      [ nil, '', 'X' * 4 ].each do |invalid_value|
        lambda {
          SEPA::DebtTransaction.new :sequence_type => invalid_value
        }.should raise_error(ArgumentError, /Sequence Type/)
      end
    end
  end
end
