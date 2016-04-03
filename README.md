# Infos

The project allows you to manage your meetings by sharing pools.

# How does it work

## Install

Install ruby 2, and ruby gems:

```sh
gem install bundler
bundle install
```

Then install the database:

```sh
cp config/database.yml.example config/database.yml
edit config/database.yml # ...
rake db:create
rake db:migrate
rake db:seed
```

## Start

```bash
rails s
```
