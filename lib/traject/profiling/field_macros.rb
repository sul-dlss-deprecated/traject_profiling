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
        lambda do |record, accumulator, _context|
          num_fields = record.fields(tag).size
          accumulator << num_fields.to_s if num_fields > 0
        end
      end

      # gets the all the values of an indicator for a tag in a marc record.
      #   If no occurrences of the tag in the marc record, accumulator is not
      #   altered (field should be missing in output_hash).
      #   If multiple occurrences, there is a single output value for each unique indicator value.
      # @param [String] tag - marc field tag; three chars (usually but not necessarily numeric)
      # @param [Object] which_ind - can be '1' or '2' (Strings) or 1 or 2 (int);
      #   any other value and accumulator is not altered (field should be missing in output_hash)
      # @param [Boolean] dedup - set to false if duplicate values should produce duplicate output values
      # @return [lambda] lambda expression appropriate for "to_field", with the values of the specified
      #   indicator for tag param added to in the lambda's accumulator param
      def field_ind(tag, which_ind, dedup=true)
        lambda do |record, accumulator, _context|
          ind_vals = []
          fields = record.fields(tag)
          fields.each do |fld|
            case which_ind
            when '1', 1
              ind_vals << fld.indicator1.to_s
            when '2', 2
              ind_vals << fld.indicator2.to_s
            end
          end
          if dedup
            accumulator.replace ind_vals.uniq
          else
            accumulator.replace ind_vals
          end
        end
      end

      # gets the all the subfield codes for a tag in a marc record.
      #   If no occurrences of the tag in the marc record, accumulator is not
      #   altered (field should be missing in output_hash).
      #   If multiple occurrences, there is a single output value for each unique subfield code.
      # @param [String] tag - marc field tag; three chars (usually but not necessarily numeric)
      # @param [Boolean] dedup - set to false if duplicate values should produce duplicate output values
      # @return [lambda] lambda expression appropriate for "to_field", with the subfield codes
      #   for tag param added to in the lambda's accumulator param
      def field_codes(tag, dedup=true)
        lambda do |record, accumulator, _context|
          codes = []
          fields = record.fields(tag)
          fields.each do |fld|
            codes << fld.codes(dedup)
          end
          if dedup
            accumulator.replace codes.flatten.uniq
          else
            accumulator.replace codes.flatten
          end
        end
      end

    end # module Macros

  end # Profiling class
end # Traject module
