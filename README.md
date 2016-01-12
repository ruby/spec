# The Ruby Spec Suite

[![Build Status](https://travis-ci.org/ruby/spec.svg)](https://travis-ci.org/ruby/spec)

The Ruby Spec Suite is a test suite for the behavior of the Ruby programming language.

It focuses on describing the behavior of Ruby and not just being a set of test cases.
Having the behavior clearly explained for every example has several advantages:

* It is easier to understand the intent of the author
* It documents how recent versions of Ruby should behave
* It helps Ruby implementations to agree on a common behavior

The specs are written with syntax similar to RSpec 2.
They are run with MSpec, the purpose-built framework for running the Ruby Spec Suite.
For more information, see the [MSpec](http://github.com/ruby/mspec) project.

The specs describe the [language syntax](language/), the [core library](core/) and the [standard library](library/).
The language specs are grouped by keyword while the core and standard library specs are grouped by class and method.

### Running the specs

First, clone this repository:

    $ git clone https://github.com/ruby/spec.git

Then move to it:

    $ cd spec

Clone [MSpec](http://github.com/ruby/mspec):

    $ git clone https://github.com/ruby/mspec.git ../mspec

And run the spec suite:

    $ ../mspec/bin/mspec

This will execute all the specs using the executable named `ruby` on your current PATH.

### Running Specs with a Specific Ruby Implementation

Use the `-t` option to specify the Ruby implementation with which to run the specs.  
The argument may be a full path to the Ruby binary.

    $ ../mspec/bin/mspec -t /path/to/some/bin/ruby

### Running Selected Specs

To run a single spec file, pass the filename to `mspec`:

    $ ../mspec/bin/mspec core/kernel/kind_of_spec.rb

You can also pass a directory, in which case all specs in that directories will be run:

    $ ../mspec/bin/mspec core/kernel

Finally, you can also run them per group as defined in `default.mspec`.  
The following command will run all language specs:

    $ ../mspec/bin/mspec :language

In similar fashion, the following commands run the respective specs:

    $ ../mspec/bin/mspec :core
    $ ../mspec/bin/mspec :library
    $ ../mspec/bin/mspec :capi

### Contributing

See [CONTRIBUTING.md](https://github.com/ruby/spec/blob/master/CONTRIBUTING.md).
