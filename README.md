# Kypsy
## Website

http://kypsy.com

[![Build Status](https://travis-ci.org/kypsy/website.svg?branch=master)](https://travis-ci.org/kypsy/website)
[![Code Climate](https://codeclimate.com/github/kypsy/website.png)](https://codeclimate.com/github/kypsy/website)

## Description

**[Kypsy](https://kypsy.com)**
is a Rails powered site for women finding friends in a new location.

- Profiles
- Photos
- Person to person messages
- Crushes
- Bookmarks

That's it. For now.

Profiles are simple free form text "bios" and unlimited photos with optional captions.

Profiles also have two lists of three properties.

**What I Am**:

- My interests (nouns)
- My activities (verbs)

**What I'm Looking For**:

- Their interests (nouns)
- Their activities (verbs)

## Requirements

- [Ruby,  ~> 2.4.0](http://ruby-lang.org)
- [Rails, ~> 5.0.1](https://github.com/rails/rails)
- [ImageMagick](http://imagemagick.org) (`brew install imagemagick@6 && brew link --force imagemagick@6`)

## Installation

```bash
git clone git@github.com:kypsy/website.git
cd website
bundle
```

#### Setup Database

```bash
cp config/database.example.yml config/database.yml
```

Update values to reflect your local environment.

#### Redis

```
brew install redis
```

#### Setup ENV vars

Create a .env file
```bash
touch .env
```

Add all required variables to `.env` using `doc/sample-dotenv` as a guide.

#### Import Production data

```bash
rake db:create
rake db:migrate
rake db:import
```

## Usage

```bash
foreman start -p 3000
```

## Authors

  * Shane Becker / [@veganstraightedge](https://github.com/veganstraightedge)
  * Bookis Smuin / [@bookis](https://github.com/bookis)

## Contribution

1. Fork it
2. Get it running
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Write your code and **specs**
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/kypsy/website).


## License

**PUBLIC DOMAIN**

Your heart is as free as the air you breathe. <br>
The ground you stand on is liberated territory.

In legal text, *Kypsy Ruby on Rails powered website* is dedicated to the public domain
using Creative Commons -- CC0 1.0 Universal.

[http://creativecommons.org/publicdomain/zero/1.0](http://creativecommons.org/publicdomain/zero/1.0 "Creative Commons — CC0 1.0 Universal")
