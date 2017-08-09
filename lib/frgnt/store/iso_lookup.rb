module Frgnt
  module Store
    class ISOLookup

      XML = MultiXml.parse(File.open(File.expand_path('../../assets/iso_4217.xml',__FILE__)))

      class << self
        def find(str)
          array = XML['ISO_4217']['CcyTbl']['CcyNtry'].select {|ccy| ccy['Ccy'] == str}
          array.any? ? array.first['CcyNm'] : ''
        end
      end
    end
  end
end
