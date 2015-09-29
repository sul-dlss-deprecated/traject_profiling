
RSpec.describe 'field_macros' do

  let!(:indexer) {
    i = Traject::Indexer.new
    i.instance_eval do
      extend Traject::Profiling::Macros
    end
    i
  }

  context "field_count" do
    let!(:record) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">245a</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Slippery noodles</subfield>
            </datafield>
            <datafield tag="700" ind1="1" ind2=" ">
              <subfield code="a">Potter, Harry.</subfield>
            </datafield>
            <datafield tag="700" ind1="1" ind2=" ">
              <subfield code="a">Snape, Severus.</subfield>
            </datafield>
          </record>'
      parse_marc(marcxml_str)
    }

    it 'single occurrence of tag' do
      indexer.instance_eval do
        to_field '245count', field_count('245')
      end
      output = indexer.map_record(record)
      expect(output['245count']).to eq ['1']
    end
    it 'mult occurrences of tag' do
      indexer.instance_eval do
        to_field '700count', field_count('700')
      end
      output = indexer.map_record(record)
      expect(output['700count']).to eq ['2']
    end
    it 'no occurrences of tag: field not in output_hash' do
      indexer.instance_eval do
        to_field '100count', field_count('100')
      end
      output = indexer.map_record(record)
      expect(output['100count']).to eq nil
    end
  end # field_count

end

# @param [String] marcxml_str an xml representation of a MARC record
# @raise [Marc::Exception] if nil returned from MARC::XMLReader
# @return [MARC::Record] parsed marc_record
def parse_marc(marcxml_str)
  marc_record = MARC::XMLReader.new(StringIO.new(marcxml_str)).to_a.first
  fail(MARC::Exception, "unable to parse marc record: " + marcxml_str, caller) if marc_record.nil?
  marc_record
end
