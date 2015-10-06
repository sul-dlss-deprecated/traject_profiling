RSpec.describe 'field_macros' do

  let!(:indexer) do
    i = Traject::Indexer.new
    i.instance_eval do
      extend Traject::Profiling::Macros
    end
    i
  end # let! indexer

  context 'field_count' do
    let!(:record) do
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
    end # let! record

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
    let!(:record) do
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
    end # let! record

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
      expect(indexer.map_record(parse_marc(marcxml))['f700ind1']).to eq %w(1 2 3)
    end
    it 'blank value included' do
      indexer.instance_eval do
        to_field 'f700ind1', field_ind('700', 1)
      end
      expect(indexer.map_record(record)['f700ind1']).to eq [' ']
    end
    it 'non-alphanum values included' do
      indexer.instance_eval do
        to_field 'f700ind2', field_ind('700', 2)
      end
      expect(indexer.map_record(record)['f700ind2']).to eq ['_']
    end
    it 'no occurrences of tag: field not in output_hash' do
      indexer.instance_eval do
        to_field 'f245ind1', field_ind('245', 1)
      end
      expect(indexer.map_record(record)['f245ind1']).to eq nil
    end
    context 'dedup=false' do
      it 'multiple occurrences of single value' do
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
          to_field 'f700ind1', field_ind('700', 1, false)
          to_field 'f700ind2', field_ind('700', 2, false)
        end
        expect(indexer.map_record(parse_marc(marcxml))['f700ind1']).to eq ['1', '1']
        expect(indexer.map_record(parse_marc(marcxml))['f700ind2']).to eq [' ', ' ']
      end
    end # dedup=false
  end # field_ind

  context 'field_codes' do
    it 'single occurrence of single subfield in single tag' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1=" " ind2=" " tag="035">
              <subfield code="a">(OCoLC-I)872526434</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('035')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq ['a']
    end
    it 'single occurrence of multiple subfields in single tag' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1=" " ind2=" " tag="300">
              <subfield code="a">2 videodiscs :</subfield>
              <subfield code="b">sound, color ;</subfield>
              <subfield code="c">4 3/4 in. +</subfield>
              <subfield code="e">2 booklets (24 cm)</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('300')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(a b c e)
    end
    it 'single occurrence of multiple subfields in multiple tags' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1=" " ind2="4" tag="666">
              <subfield code="a">suba</subfield>
              <subfield code="b">subb</subfield>
            </datafield>
            <datafield ind1=" " ind2="4" tag="666">
              <subfield code="c">subc</subfield>
              <subfield code="d">subd</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('666')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(a b c d)
    end
    it 'multiple occurrences of single subfield in single tags' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield tag="040" ind1=" " ind2=" ">
              <subfield code="a">BTCTA</subfield>
              <subfield code="c">BTCTA</subfield>
              <subfield code="d">OHX</subfield>
              <subfield code="d">YDXCP</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('040')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(a c d)
    end
    it 'multiple occurrences of subfields in multiple tags' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1=" " ind2="0" tag="650">
              <subfield code="a">Food habits</subfield>
              <subfield code="z">China</subfield>
              <subfield code="x">History.</subfield>
            </datafield>
            <datafield ind1=" " ind2="0" tag="650">
              <subfield code="a">Cooking</subfield>
              <subfield code="z">China</subfield>
              <subfield code="x">History.</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('650')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(a z x)
    end
    it 'numeric subfields included' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">suba</subfield>
              <subfield code="b">subb</subfield>
              <subfield code="c">subc</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('245')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(6 a b c)
    end
    it 'non-alphanum values included' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1=" " ind2="0" tag="650">
              <subfield code="a">Food habits</subfield>
              <subfield code="z">China</subfield>
              <subfield code="x">History.</subfield>
              <subfield code="=">^A2383609</subfield>
            </datafield>
            <datafield ind1="0" ind2="2" tag="730">
              <subfield code="i">Contains (work):</subfield>
              <subfield code="a">Te doy mis ojos.</subfield>
              <subfield code="?">UNAUTHORIZED</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f650_codes', field_codes('650')
        to_field 'f730_codes', field_codes('730')
      end
      output_hash = indexer.map_record(parse_marc(marcxml_str))
      expect(output_hash['f650_codes']).to eq %w(a z x =)
      expect(output_hash['f730_codes']).to eq %w(i a ?)
    end
    it 'no occurrences of tag: field not in output_hash' do
      marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">field_codes</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
          </record>'
      indexer.instance_eval do
        to_field 'f_codes', field_codes('245')
      end
      expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq nil
    end
    context 'dedup=false' do
      it 'multiple occurrences of single subfield in single tags' do
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01052cam a2200313 i 4500</leader>
              <controlfield tag="001">field_codes</controlfield>
              <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
              <datafield tag="040" ind1=" " ind2=" ">
                <subfield code="a">BTCTA</subfield>
                <subfield code="c">BTCTA</subfield>
                <subfield code="d">OHX</subfield>
                <subfield code="d">YDXCP</subfield>
                <subfield code="d">DLC</subfield>
              </datafield>
            </record>'
        indexer.instance_eval do
          to_field 'f_codes', field_codes('040', false)
        end
        expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(a c d d d)
      end
      it 'multiple occurrences of subfields in multiple tags' do
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01052cam a2200313 i 4500</leader>
              <controlfield tag="001">field_codes</controlfield>
              <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
              <datafield tag="505" ind1=" " ind2=" ">
                <subfield code="t">blah</subfield>
                <subfield code="t">blah</subfield>
              </datafield>
              <datafield tag="505" ind1=" " ind2=" ">
                <subfield code="t">blah</subfield>
                <subfield code="t">blah</subfield>
              </datafield>
            </record>'
        indexer.instance_eval do
          to_field 'f_codes', field_codes('505', false)
        end
        expect(indexer.map_record(parse_marc(marcxml_str))['f_codes']).to eq %w(t t t t)
      end
    end # dedup=false
  end # field_codes

end
