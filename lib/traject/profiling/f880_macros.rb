module Traject
  class Profiling

    # traject "macros" to be used with #to_field in a traject config file
    module Macros

      # to_field 'f880_for', profile_880_tags
      # to_field 'f880_for', profile_880_tags_and_subfields

      # TODO: naomi_must_comment_and_test_this_method
      # what tags are the 880s FOR
      # @param [Boolean] dedup - set to false if duplicate values should produce duplicate output values
      # counts the number of occurrences of a field in a marc record.
      #   If no occurrences, accumulator is not altered (field should be missing in output_hash)
      # @param [String] tag - marc field tag; three chars (usually but not neccesarily numeric)
      # @return [lambda] lambda expression appropriate for "to_field", with the number of marc fields
      #   matching the tag param added to in the lambda's accumulator param
      def tags_with_880s(dedup=true)
        lambda do |record, accumulator, _context|
          record.each_by_tag('880') do |field|
            tag = field['6'][0, 3]
            if dedup
              accumulator << tag unless accumulator.include? tag
            else
              accumulator << tag
            end
          end
        end
      end

      # TODO: naomi_must_comment_and_test_this_method
      # what codes do the 880s for a particular tag have?
      # @param [Boolean] dedup - set to false if duplicate values should produce duplicate output values
      def tag_codes_in_880s(tag, dedup=true)
        lambda do |record, accumulator, _context|
          codes = []
          record.each_by_tag('880') do |field|
            tag_in_880 = field['6'][0, 3]
            if tag_in_880 == tag
              # fixme:  remove '6'!
              codes << field.codes(dedup)
              if dedup
                accumulator.replace codes.flatten.uniq
              else
                accumulator.replace codes.flatten
              end
            end
          end
        end
      end

      # TODO: naomi_must_comment_and_test_this_method
      # @param [Boolean] dedup - set to false if duplicate values should produce duplicate output values
      # if linkage data is -00
      #   (or doesn't refer to an existing field???)
      def tags_for_unassociated_880s(dedup=true)
        lambda do |record, accumulator, _context|
          record.each_by_tag('880') do |field|
            if field['6'][4, 2] == '00'
              accumulator << field['6'][0, 3]
            end
          end
        end
      end

    end # module Macros

  end # Profiling class
end # Traject module
