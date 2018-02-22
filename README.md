# AtCoderFriends

## Description

AtCoderFriends supports following operations
related to [AtCoder](https://atcoder.jp/) programming contest:

- Download example data
- Generate source skeleton
- Run test cases
- Source submission

## Dependencies

- Ruby 2.3 or newer
- [Mechanize](https://github.com/sparklemotion/mechanize)

## Installation

See [Development](#Develoment).

<!-- 
Add this line to your application's Gemfile:

```ruby
gem 'at_coder_friends'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install at_coder_friends 
-->

## Configuration

Create ```.at_coder_friends.yml``` and place it in the (parent of) working directory.

```yaml
user: <user>
password: <password>
```

## Usage

### Setup

```
at_coder_friends setup     /path/to/contest
```

Creates contest folder, and generates example data and source skeletons into the folder.


### Run tests

- first test case only

```
at_coder_friends test-one  /path/to/contest/src
```

- all test cases

```
at_coder_friends test-all  /path/to/contest/src
```

### Submit code

```
at_coder_friends submit    /path/to/contest/src
```

### Naming Convention

- Contest folder name will be used as part of the URL of the contest site.  
  For example, if ```arc001``` folder is specified, AtCoderFriends will connect to  
  ```arc001.contest.atcoder.jp```.
- Source file name should be ```[problem ID].[language specific extension]```(e.g. ```A.rb```),  
  so that AtCoderFriends can decide which test data to use, or fill the submission form automatically.
- In order to have another solution, suffixes (begins with underscore) can be added to the file name (e.g. ```A_v2.rb```).

### Notes

- Source compilation is not supported.
- Source generation supports only ruby and C++.

## For Sublime Text User

It is convenient to use AtCoderFriends from Sublime Text plug-in.

- [sublime_at_coder_friends](https://github.com/nejiko96/sublime_at_coder_friends)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
<!---
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). 
--->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nejiko96/at_coder_friends. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AtCoderFriends project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nejiko96/at_coder_friends/blob/master/CODE_OF_CONDUCT.md).
