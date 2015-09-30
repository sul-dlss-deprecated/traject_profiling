module Traject
  class Profiling

    # traject "macros" to be used with #to_field in a traject config file
    module Macros

      # to_field 'f100subflds', profile_subfields('100')

      # counts the number of occurrences of a tag in a marc record.
      #   If no occurrences, accumulator is not altered (field should be missing in output_hash)
      # @param [String] tag - marc field tag; three chars (usually but not necessarily numeric)
      # @return [lambda] lambda expression appropriate for "to_field", with the number of marc fields
      #   matching the tag param added to in the lambda's accumulator param
      def field_count(tag)
        return lambda do |record, accumulator, _context|
          num_fields = record.fields(tag).size
          accumulator << num_fields.to_s if num_fields > 0
        end
      end

      # gets the all the values of an indicator for a tag in a marc record.
      #   If no occurrences, accumulator is not altered (field should be missing in output_hash)
      # @param [String] tag - marc field tag; three chars (usually but not necessarily numeric)
      # @param [Object] which_ind - can be '1' or '2' (Strings) or 1 or 2 (int);
      #   any other value and accumulator is not altered (field should be missing in output_hash)
      # @return [lambda] lambda expression appropriate for "to_field", with the values of the specified
      #   indicator for tag param added to in the lambda's accumulator param
      def field_ind(tag, which_ind)
        ind_vals = []
        return lambda do |record, accumulator, _context|
          fields = record.fields(tag)
          fields.each do |fld|
            case which_ind
            when '1', 1
              ind_vals << fld.indicator1.to_s
            when '2', 2
              ind_vals << fld.indicator2.to_s
            end
          end
          accumulator.replace ind_vals.uniq
        end
      end

    end # module Macros

  end # Profiling class
end # Traject module
