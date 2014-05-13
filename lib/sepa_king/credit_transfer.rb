# encoding: utf-8

module SEPA
  class CreditTransfer
    attr_reader :debitor, :transactions

    def initialize(debitor_options)
      @debitor = Account.new(debitor_options)
      @transactions = []
    end

    def add_transaction(options)
      @transactions << CreditTransaction.new(options)
    end

    def to_xml
      builder = Builder::XmlMarkup.new :indent => 2
      builder.instruct!
      builder.Document :xmlns                => 'urn:iso:std:iso:20022:tech:xsd:pain.001.002.03',
                       :'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
                       :'xsi:schemaLocation' => 'urn:iso:std:iso:20022:tech:xsd:pain.001.002.03 pain.001.002.03.xsd' do
        builder.CstmrCdtTrfInitn do
          builder.GrpHdr do
            builder.MsgId(message_identification)
            builder.CreDtTm(Time.now.iso8601)
            builder.NbOfTxs(transactions.length)
            builder.InitgPty do
              builder.Nm(debitor.name)
            end
          end

          builder.PmtInf do
            builder.PmtInfId(payment_information_identification)
            builder.PmtMtd('TRF')
            builder.BtchBookg(true)
            builder.NbOfTxs(transactions.length)
            builder.CtrlSum(amount_total)
            builder.PmtTpInf do
              builder.SvcLvl do
                builder.Cd('SEPA')
              end
            end
            builder.ReqdExctnDt(Date.today.next.to_s)
            builder.Dbtr do
              builder.Nm(debitor.name)
            end
            builder.DbtrAcct do
              builder.Id do
                builder.IBAN(debitor.iban)
              end
            end
            builder.DbtrAgt do
              builder.FinInstnId do
                builder.BIC(debitor.bic)
              end
            end
            builder.ChrgBr('SLEV')
            transactions.each do |transaction|
              builder.CdtTrfTxInf do
                builder.PmtId do
                  builder.EndToEndId(transaction.reference || 'NOTPROVIDED')
                end
                builder.Amt do
                  builder.InstdAmt(transaction.amount, :Ccy => 'EUR')
                end
                builder.CdtrAgt do
                  builder.FinInstnId do
                    builder.BIC(transaction.bic)
                  end
                end
                builder.Cdtr do
                  builder.Nm(transaction.name)
                end
                builder.CdtrAcct do
                  builder.Id do
                    builder.IBAN(transaction.iban)
                  end
                end
                if transaction.remittance_information
                  builder.RmtInf do
                    builder.Ustrd(transaction.remittance_information)
                  end
                end
              end
            end
          end
        end
      end
    end

  private
    def amount_total
      transactions.inject(0) { |sum, t| sum + t.amount }
    end

    def message_identification
      "SEPA-KING/#{Time.now.iso8601}"
    end

    def payment_information_identification
      message_identification
    end
  end
end
