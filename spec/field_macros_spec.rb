
RSpec.describe 'field_macros' do

  let!(:indexer) {
    i = Traject::Indexer.new
    i.instance_eval do
      extend Traject::Profiling::Macros
    end
    i
  }

  context 'field_count' do
    let!(:record) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_count</controlfield>
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
        to_field 'f245count', field_count('245')
      end
      expect(indexer.map_record(record)['f245count']).to eq ['1']
    end
    it 'mult occurrences of tag' do
      indexer.instance_eval do
        to_field 'f700count', field_count('700')
      end
      expect(indexer.map_record(record)['f700count']).to eq ['2']
    end
    it 'no occurrences of tag: field not in output_hash' do
      indexer.instance_eval do
        to_field 'f100count', field_count('100')
      end
      expect(indexer.map_record(record)['f100count']).to eq nil
    end
  end # field_count

  context 'field_ind' do
    let!(:record) {
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_ind</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="2" tag="100">
              <subfield code="a">numeric indicators</subfield>
            </datafield>
            <datafield ind1=" " ind2="_" tag="700">
              <subfield code="a">blank and punctuation indicators</subfield>
            </datafield>
            <datafield ind1="a" ind2="b" tag="800" >
              <subfield code="a">alpha indicators</subfield>
            </datafield>
          </record>'
      parse_marc(marcxml_str)
    }
    it 'uses first indicator when second param is 1 (string)' do
      indexer.instance_eval do
        to_field 'f100ind1', field_ind('100', '1')
      end
      expect(indexer.map_record(record)['f100ind1']).to eq ['1']
    end
    it 'uses first indicator when second param is 1 (int)' do
      indexer.instance_eval do
        to_field 'f100ind1', field_ind('100', 1)
      end
      expect(indexer.map_record(record)['f100ind1']).to eq ['1']
    end
    it 'uses second indicator when second param is 2 (string)' do
      indexer.instance_eval do
        to_field 'f100ind2', field_ind('100', '2')
      end
      expect(indexer.map_record(record)['f100ind2']).to eq ['2']
    end
    it 'uses second indicator when second param is 2 (int)' do
      indexer.instance_eval do
        to_field 'f100ind2', field_ind('100', 2)
      end
      expect(indexer.map_record(record)['f100ind2']).to eq ['2']
    end
    it 'returns nil (field not in output_hash) when second param is not 1 or 2' do
      indexer.instance_eval do
        to_field 'f100ind_3', field_ind('100', '3')
        to_field 'f100ind_first', field_ind('100', 'first')
        to_field 'f100ind_a', field_ind('100', 'a')
      end
      output_hash = indexer.map_record(record)
      expect(output_hash['f100ind_3']).to eq nil
      expect(output_hash['f100ind_first']).to eq nil
      expect(output_hash['f100ind_a']).to eq nil
    end
    it 'single instance of tag returns single char value' do
      indexer.instance_eval do
        to_field 'f100ind1', field_ind('100', 1)
      end
      expect(indexer.map_record(record)['f100ind1']).to eq ['1']
    end
    it 'multiple instances of tag all with same ind value returns unrepeated char value' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_ind</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2=" " tag="700">
              <subfield code="a">numeric indicators</subfield>
            </datafield>
            <datafield ind1="1" ind2=" " tag="700">
              <subfield code="a">blank and punctuation indicators</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f700ind1', field_ind('700', 1)
      end
      expect(indexer.map_record(parse_marc(marcxml))['f700ind1']).to eq ['1']
    end
    it 'each char used in indicator is a separate value' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_ind</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2=" " tag="700">
              <subfield code="a">numeric indicators</subfield>
            </datafield>
            <datafield ind1="2" ind2=" " tag="700">
              <subfield code="a">blank and punctuation indicators</subfield>
            </datafield>
            <datafield ind1="3" ind2=" " tag="700">
              <subfield code="a">blank and punctuation indicators</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f700ind1', field_ind('700', 1)
      end
      expect(indexer.map_record(parse_marc(marcxml))['f700ind1']).to eq ['1', '2', '3']
    end
    it 'blank value is honored' do
      indexer.instance_eval do
        to_field 'f700ind1', field_ind('700', 1)
      end
      expect(indexer.map_record(record)['f700ind1']).to eq [' ']
    end
    it 'non-alphanum values are honored' do
      indexer.instance_eval do
        to_field 'f700ind2', field_ind('700', 2)
      end
      expect(indexer.map_record(record)['f700ind2']).to eq ['_']
    end
  end

end

# @param [String] marcxml_str an xml representation of a MARC record
# @raise [Marc::Exception] if nil returned from MARC::XMLReader
# @return [MARC::Record] parsed marc_record
def parse_marc(marcxml_str)
  marc_record = MARC::XMLReader.new(StringIO.new(marcxml_str)).to_a.first
  fail(MARC::Exception, 'unable to parse marc record: ' + marcxml_str, caller) if marc_record.nil?
  marc_record
end
