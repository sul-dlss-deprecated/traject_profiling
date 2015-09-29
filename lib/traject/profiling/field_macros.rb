module Traject
  class Profiling

    module Macros

      # to_field 'f100ind1', field_ind('100', '1')
      # to_field 'f100ind2', field_ind('100', '2')
      # to_field 'f100subflds', profile_subfields('100')

      # counts the number of occurrences of a field in a marc record.
      #   If no occurrences, accumulator is not altered (field should be missing in output_hash)
      # @param [String] tag - marc field tag; three chars (usually but not neccesarily numeric)
      # @return [lambda] lambda expression appropriate for "to_field", with the number of marc fields
      #   matching the tag param added to in the lambda's accumulator param
      def field_count(tag)
        return lambda do |record, accumulator, context|
          num_fields = record.fields(tag).size
          accumulator << num_fields.to_s if num_fields > 0
        end
      end

    end # module Macros

  end
end