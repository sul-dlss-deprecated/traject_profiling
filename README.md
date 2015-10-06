[![Build Status](https://travis-ci.org/sul-dlss/traject_profiling.svg?branch=master)](https://travis-ci.org/sul-dlss/traject_profiling) [![Coverage Status](https://coveralls.io/repos/sul-dlss/traject_profiling/badge.png)](https://coveralls.io/r/sul-dlss/traject_profiling) [![Dependency Status](https://gemnasium.com/sul-dlss/traject_profiling.svg)](https://gemnasium.com/sul-dlss/traject_profiling) [![Gem Version](https://badge.fury.io/rb/traject_profiling.svg)](http://badge.fury.io/rb/traject_profiling)

# traject_profiling

Traject macros to provide profiling information on MARC bibliographic records.

This code is meant to be used with [traject](http://github.com/traject/traject) to index MARC records into [Solr](http://lucene.apache.org/solr).

## Usage

### A sample traject configuration file using macros from traject_profiling

```ruby
require 'traject'
require 'traject/profiling'
extend Traject::Profiling::Macros

to_field 'id',          extract_marc('001', :first=>true)
to_field 'f700count',   field_count('700')
to_field 'f700ind1',    field_ind_vals('700', '1') # 700 ind1 values
to_field 'f700ind2',    field_ind_vals('700', '2')
to_field 'f700codes',   field_codes('700')  # subfield codes used in 700 fields
to_field 'f880_for',    tags_with_880s()
to_field 'f880codes_for_700',    tag_codes_in_880s('700')
to_field 'orphan_880s', tags_for_unassociated_880s

```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'traject_profiling'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traject_profiling

## Contributing

1. Fork it ( https://github.com/[my-github-username]/traject_profiling/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
