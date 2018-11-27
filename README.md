# ZappSdkTasks

This repo provides various rake tasks to be used on any new Zapp sdk repo you
create.

## Installation
**Prerequisites**

```
ruby >= 2.3.5
```

Add this line to your application's Gemfile:

```ruby
gem 'zapp_sdk_tasks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zapp_sdk_tasks

## Usage

This repo contains two tasks:

#### Create Zapp SDK

This task creates a stable or Canary (preview) sdk on Zapp, using a tag or
branch name.

Run:
`bundle exec rake zapp_sdks:create[<platform as defined in zapp>,<version e.g. 1.0.0>,<sdk repo name>,<zapp token>]`

Make sure the params are comma-separated without whitespaces

**Params**

param        | description
----------------|-------------|
platform        | The platform supported by the current published sdk (Currently supporting `android/ios/roku/tvos/samsung_tv`)   |
version         | The requireed version for the published sdk. *Note: only semver stable/final and preview versions will publish the sdk in zapp* |
repository name | The sdk repo name  |
zapp token      | Zapp API access token  |

#### Publish Changelog

This task creates and publish changelog to Amazon s3.
**Make sure you setup `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION` environment variable in order to use this task.

Run:
`bundle exec rake zapp_sdks:publish_changelog[<platform as defined in zapp>,<version e.g. 1.0.0>]`

Make sure the params are comma-separated without whitespaces

**Params**

param        | description
----------------|-------------|
platform        | The platform supported by the current published sdk (Currently supporting `android/ios/roku/tvos/samsung_tv`)   |
version         | The requireed version for the published sdk  |


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/applicaster/zapp_sdk_tasks. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the ZappSdkTasks project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/applicaster/zapp_sdk_tasks/blob/master/CODE_OF_CONDUCT.md).
