# encoding: utf-8
module SEPA
  class Transaction
    include TextConverter
    attr_reader :name, :iban, :bic, :amount, :reference, :remittance_information

    def initialize(options)
      options.each_pair do |k,v|
        send("#{k}=", v)
      end
    end

    def name=(value)
      raise ArgumentError.new('Name is missing') if value.nil? || value.empty?
      raise ArgumentError.new("Name is too long: #{value.length}, must be 70 maximum") if value.length > 70
      @name = convert_text(value)
    end

    def iban=(value)
      raise ArgumentError.new('IBAN is missing') if value.nil? || value.empty?
      raise ArgumentError.new('IBAN is invalid') unless IBANTools::IBAN.valid?(value)
      @iban = value
    end

    def bic=(value)
      raise ArgumentError.new('BIC is missing') if value.nil? || value.empty?
      raise ArgumentError.new("BIC has wrong length: #{value.length} must be between 8-11") unless value.length.between?(8,11)
      @bic = value
    end

    def amount=(value)
      raise ArgumentError.new('Amount is not a number') unless value.is_a?(Numeric)
      raise ArgumentError.new('Amount cannot be zero') if value.zero?
      raise ArgumentError.new('Amount cannot be negative') if value < 0
      rounded_amount = (value*100).round / 100.0
      raise ArgumentError.new('Amount has more than 2 digits') if rounded_amount != value
      @amount = value
    end

    def reference=(value)
      raise ArgumentError.new('Reference is missing') if value.nil? || value.empty?
      raise ArgumentError.new("Reference is too long: #{value.length}, must be 35 maximum") if value.length > 35
      @reference = convert_text(value)
    end

    def remittance_information=(value)
      if value
        raise ArgumentError.new('Remittance information has to be a string') unless value.is_a?(String)
        raise ArgumentError.new('Remittance information cannot be blank') if value.empty?
        raise ArgumentError.new("Remittance information is too long: #{value.length}, must be 140 maximum") if value.length > 140
      end
      @remittance_information = convert_text(value)
    end
  end
end
