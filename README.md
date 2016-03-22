# Stewfinder

This gem provides command line utilities for working locally with [Ladle](https://github.com/appfolio/ladle) style stewards files.

## Installation

Install via the command line:

    $ gem install stewfinder

Or add it to the Gemfile of your application, if you'd like to make it available to all developers:

```ruby
gem 'stewfinder'
```

## Usage

Run it from your terminal:

    stewfinder /path/to/file.rb

Output looks like this:

    Stewards for this file:
     - XanderStrike
     - bboe

For extra points, add it as a build configuration in your favorite text editor! In Sublime do ⌘+⇧+P "New Build System" and paste in the following:

```json
{
  "shell_cmd": "stewfinder $file"
}
```

You can now find it with ⌘+⇧+P "stewards" or bind it to a hotkey!

## Contributing

1. Fork it ( https://github.com/appfolio/stewfinder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
