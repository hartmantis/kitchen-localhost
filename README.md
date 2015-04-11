[![Gem Version](https://badge.fury.io/rb/kitchen-localhost.png)](http://badge.fury.io/rb/kitchen-localhost)
[![Build Status](https://travis-ci.org/test-kitchen/kitchen-localhost.png?branch=master)](https://travis-ci.org/test-kitchen/kitchen-localhost)
[![Code Climate](https://codeclimate.com/github/test-kitchen/kitchen-localhost.png)](https://codeclimate.com/github/test-kitchen/kitchen-localhost)
[![Coverage Status](https://coveralls.io/repos/test-kitchen/kitchen-localhost/badge.png)](https://coveralls.io/r/test-kitchen/kitchen-localhost)
[![Dependency Status](https://gemnasium.com/test-kitchen/kitchen-localhost.png)](https://gemnasium.com/test-kitchen/kitchen-localhost)

Kitchen::Localhost
==================

A Test Kitchen Driver for when you just want to run Chef on localhost.

I swear, there's a reason this driver exists! Sometimes there are cases where
you want to run Test Kitchen against your CI build server (e.g. using Travis
CI's Objective-C build environments to do OS X cookbook testing). This driver
allows you to do everything from Kitchen instead of separately shelling out
for that one special platform.

Requirements
------------

Nothing other than a project you wish to test with Test Kitchen and an
understanding that this driver will be running against _your local machine_. If
you write a cookbook that formats a hard drive and run it with this driver, bad
things will happen.

Installation and Setup
----------------------

Add this line to your project's Gemfile:

    gem 'kitchen-localhost'

...and then execute:

    $ bundle install

...or install it yourself as:

    $ gem install kitchen-localhost

Configuration
-------------

Contributing
------------

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. `bundle install`
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Ensure your feature has tests and `rake` passes
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
8. Keep an eye on the PR and ensure the CI build passes

_New features that have no tests and changes that cause the CI build to fail
will not be merged_

Authors
-------

Created and maintained by [Jonathan Hartman][author] (<j@p4nt5.com>)

License
-------

Apache 2.0 (see [LICENSE][license])

[author]:           https://github.com/roboticcheese
[issues]:           https://github.com/roboticcheese/kitchen-localhost/issues
[license]:          https://github.com/roboticcheese/kitchen-localhost/blob/master/LICENSE
[repo]:             https://github.com/roboticcheese/kitchen-localhost
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.getchef.com/chef/install/
