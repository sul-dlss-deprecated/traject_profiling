# traject_profiling

Traject macros to provide profiling information on MARC bibliographic records.

This code is meant to be used with [traject](http://github.com/traject/traject) to index MARC records into [Solr](http://lucene.apache.org/solr).

## Usage

### A sample traject configuration file

```ruby
require 'traject'
require 'traject/profiling'
extend Traject::Profiling::Macros

to_field 'id', extract_marc('001', :first=>true)
to_field 'f100count', profile_tag_count('100')
to_field 'f100ind1', profile_ind('100', '1')
to_field 'f100ind2', profile_ind('100', '2')
to_field 'f100subflds', profile_subfields('100')
to_field 'f880_for', profile_880_tags
to_field 'f880_for', profile_880_tags_and_subfields

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
