[![Gem Version](https://img.shields.io/gem/v/kitchen-localhost.svg)][gem]
[![Linux Build Status](https://img.shields.io/travis/RoboticCheese/kitchen-localhost.svg)][travis]
[![Windows Build Status](https://img.shields.io/appveyor/ci/RoboticCheese/kitchen-localhost.svg)][appveyor]
[![OS X Build Status](https://img.shields.io/circleci/project/RoboticCheese/kitchen-localhost.svg)][circle]
[![Code Climate](https://img.shields.io/codeclimate/github/RoboticCheese/kitchen-localhost.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/RoboticCheese/kitchen-localhost.svg)][coveralls]
[![Dependency Status](https://img.shields.io/gemnasium/RoboticCheese/kitchen-localhost.svg)][gemnasium]

[gem]: https://rubygems.org/gems/kitchen-localhost
[travis]: https://travis-ci.org/RoboticCheese/kitchen-localhost
[appveyor]: https://ci.appveyor.com/project/RoboticCheese/kitchen-localhost
[circle]: https://circleci.com/gh/RoboticCheese/kitchen-localhost
[codeclimate]: https://codeclimate.com/github/RoboticCheese/kitchen-localhost
[coveralls]: https://coveralls.io/r/RoboticCheese/kitchen-localhost
[gemnasium]: https://gemnasium.com/RoboticCheese/kitchen-localhost

Kitchen::Localhost
==================

A Test Kitchen Driver for when you just want to run Chef on localhost.

I swear, there's a reason this driver exists!

TravisCI has a wonderful OS X build environment and AppVeyor a Windows one.
This driver allows you to use either as a test environment--having the platform
under test be the one running Test Kitchen, rather than a remote cloud
server--all while keeping the same Kitchen settings, behavior, and log output
you're used to.

Requirements
------------

Nothing other than a project you wish to test with Test Kitchen and an
understanding that this driver will be running against _your local machine_. If
you write a cookbook that formats a hard drive and run it with this driver, bad
things will happen.

This driver attempts to minimize cases of multiple test suites clobbering each
other by never running concurrently, even if the `-c` option is passed to Test
Kitchen. But everything is still running on the same machine. Don't define
multiple suites unless they're okay to run, serially, on a single server.

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

Just override one of the platforms in your Kitchen config to use this driver.
That's it!

    ---
    driver:
      name: vagrant

    provisioner:
      name: chef_zero

    platforms:
      - name: ubuntu-14.04
      - name: centos-7.0
      - name: macosx-10.10
        driver:
          name: localhost

    suites:
      - name: default
        run_list:
          - recipe[something]

Optionally, you can configure the driver to leave behind Test Kitchen's temp
directories when it does a `kitchen destroy`:

    ---
    driver:
      name: localhost
      clean_up_on_destroy: false

This can be useful if, for example, you have a CI system that's slow to install
gems and you want to have it cache Busser + its plugins.

Contributing
------------

Pull requests are very welcome! Make sure your patches are well tested. Ideally
create a topic branch for every separate change you make. For example:

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

[author]:           https://github.com/RoboticCheese
[issues]:           https://github.com/RoboticCheese/kitchen-localhost/issues
[license]:          https://github.com/RoboticCheese/kitchen-localhost/blob/master/LICENSE.txt
[repo]:             https://github.com/RoboticCheese/kitchen-localhost
[driver_usage]:     http://docs.kitchen-ci.org/drivers/usage
[chef_omnibus_dl]:  http://www.getchef.com/chef/install/
