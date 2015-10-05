RSpec.describe 'f880_macros' do

  let!(:indexer) do
    i = Traject::Indexer.new
    i.instance_eval do
      extend Traject::Profiling::Macros
    end
    i
  end # let! indexer

  context 'tags_with_880s' do
    it 'each 880\'s tag' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">Fen nu de pu tao =</subfield>
              <subfield code="b">The grapes of wrath /</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="6">880-02</subfield>
              <subfield code="a">Shanghai Shi :</subfield>
              <subfield code="c">2003.</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄 =</subfield>
              <subfield code="b">The grapes of wrath /</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="880">
              <subfield code="6">260-02</subfield>
              <subfield code="a">上海市 :</subfield>
              <subfield code="c">2003.</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq %w(245 260)
    end
    it 'assoc fields do not need to be consecutive' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">Fen nu de pu tao =</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="6">880-03</subfield>
              <subfield code="a">Shanghai Shi :</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄 =</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="880">
              <subfield code="6">260-03</subfield>
              <subfield code="a">上海市 :</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq %w(245 260)
    end
    it 'do not include tags without 880s (no |6 )' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2=" " tag="100">
              <subfield code="a">Steinbeck, John,</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">Fen nu de pu tao =</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄 =</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).not_to include('100')
    end
    it 'do not include tags without 880s (even if they have |6 )' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2=" " tag="100">
              <subfield code="6">880-02</subfield>
              <subfield code="a">Steinbeck, John,</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">Fen nu de pu tao =</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄 =</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).not_to include('100')
    end
    it 'include 880 even if assoc field missing (and not 00 assoc number)' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">Fen nu de pu tao =</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄 =</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="880">
              <subfield code="6">250-02</subfield>
              <subfield code="a">第1版.</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to include('250')
    end
    it 'include 880s with 00 assoc number' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">The grapes of wrath /</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">246-00</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq ['246']
    end
    it 'script identified in 880 |6' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01564cam a2200409 a 4500</leader>
          <controlfield tag="001">13850373</controlfield>
          <controlfield tag="008">050125s2004    cc a     b    000 0 chi d</controlfield>
          <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="6">880-04</subfield>
            <subfield code="a">Qu, Wei</subfield>
          </datafield>
          <datafield tag="880" ind1="1" ind2=" ">
            <subfield code="6">700-04/$1</subfield>
            <subfield code="a">&#x66F2;&#x4F1F;</subfield>
          </datafield>
        </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq ['700']
    end
    it 'repeated tags with 880s are deduped by default' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01564cam a2200409 a 4500</leader>
          <controlfield tag="001">13850373</controlfield>
          <controlfield tag="008">050125s2004    cc a     b    000 0 chi d</controlfield>
          <datafield tag="245" ind1="0" ind2="0">
            <subfield code="a"> Haerbin Youtai ren =</subfield>
            <subfield code="b">Collection of research papers on Harbin Jews /</subfield>
          </datafield>
          <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="6">880-04</subfield>
            <subfield code="a">Qu, Wei</subfield>
          </datafield>
          <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="6">880-05</subfield>
            <subfield code="a">Li, Shuxiao.</subfield>
          </datafield>
          <datafield tag="880" ind1="1" ind2=" ">
            <subfield code="6">700-04/$1</subfield>
            <subfield code="a">&#x66F2;&#x4F1F;</subfield>
          </datafield>
          <datafield tag="880" ind1="1" ind2=" ">
            <subfield code="6">700-05/$1</subfield>
            <subfield code="a">&#x674E;&#x8FF0;&#x7B11;.</subfield>
          </datafield>
        </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq ['700']
    end
    it 'dedup=false' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
          <leader>01564cam a2200409 a 4500</leader>
          <controlfield tag="001">13850373</controlfield>
          <controlfield tag="008">050125s2004    cc a     b    000 0 chi d</controlfield>
          <datafield tag="245" ind1="0" ind2="0">
            <subfield code="a"> Haerbin Youtai ren =</subfield>
            <subfield code="b">Collection of research papers on Harbin Jews /</subfield>
          </datafield>
          <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="6">880-04</subfield>
            <subfield code="a">Qu, Wei</subfield>
          </datafield>
          <datafield tag="700" ind1="1" ind2=" ">
            <subfield code="6">880-05</subfield>
            <subfield code="a">Li, Shuxiao.</subfield>
          </datafield>
          <datafield tag="880" ind1="1" ind2=" ">
            <subfield code="6">700-04/$1</subfield>
            <subfield code="a">&#x66F2;&#x4F1F;</subfield>
          </datafield>
          <datafield tag="880" ind1="1" ind2=" ">
            <subfield code="6">700-05/$1</subfield>
            <subfield code="a">&#x674E;&#x8FF0;&#x7B11;.</subfield>
          </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s(false)
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq %w(700 700)
    end
    it 'do not include tags without 880s' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">title</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq nil
    end
    it 'no 880s: field not in output_hash' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">880s</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
          </record>'
      indexer.instance_eval do
        to_field 'tags_w_880s', tags_with_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['tags_w_880s']).to eq nil
    end
  end # tags_with_880s

  context 'tag_codes_in_880s' do
    it 'gets all codes other than 6' do
      fail 'test to be implemented'
    end
    it 'does not include 6' do
      fail 'test to be implemented'
    end
    it 'gets numeric codes' do
      fail 'test to be implemented'
    end
    it 'gets non-alphanum codes' do
      fail 'test to be implemented'
    end
    it 'multiple 880s for same tag' do
      fail 'test to be implemented'
    end
    it 'multiple occurrences of same code in separate 880s for same tag' do
      fail 'test to be implemented'
    end
    it 'dedup=false' do
      fail 'test to be implemented'
    end
    it 'no 880s: field not in output_hash' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">880s</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
          </record>'
      indexer.instance_eval do
        to_field 'f245_880_codes', tag_codes_in_880s('245')
      end
      expect(indexer.map_record(parse_marc(marcxml))['f245_880_codes']).to eq nil
    end
    it 'no assoc 880s: field not in output hash' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">880s</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">title</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'f246_880_codes', tag_codes_in_880s('246')
      end
      expect(indexer.map_record(parse_marc(marcxml))['f246_880_codes']).to eq nil
    end
  end # tag_codes_in_880s

  context 'tags_for_unassociated_880s' do
    it 'takes first 3 chars when occurrence number is 00' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">title</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-00</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">zZZ-00</subfield>
              <subfield code="a">anything</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq %w(245 zZZ)
    end
    it "doesn't require associated field for -00" do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">246-00</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq ['246']
    end
    it "included if assoc field is missing" do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Fen nu de pu tao =</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="880">
              <subfield code="6">250-02</subfield>
              <subfield code="a">第1版.</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq ['250']
    end
    it 'dedup=false' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">246-00</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">246-00</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq %w(246 246)
    end
    it "ignores tags referring to non-existent 880s" do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01942cam a2200505Ia 4500</leader>
            <controlfield tag="001">f880s</controlfield>
            <controlfield tag="008">140709s2003    cc            000 1 chird</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">title</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq nil
    end
    it 'no 880s: field not in output_hash' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">880s</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq nil
    end
    it 'no unassoc 880s: field not in output hash' do
      marcxml =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">880s</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="6">880-01</subfield>
              <subfield code="a">title</subfield>
            </datafield>
            <datafield ind1="1" ind2="0" tag="880">
              <subfield code="6">245-01</subfield>
              <subfield code="a">愤怒的葡萄</subfield>
            </datafield>
          </record>'
      indexer.instance_eval do
        to_field 'orphan_880s', tags_for_unassociated_880s
      end
      expect(indexer.map_record(parse_marc(marcxml))['orphan_880s']).to eq nil
    end
  end # tags_for_unassociated_880s

end