# StockedShelves

A web application for keeping track of all the food you have.

## Ruby version and dependencies

- built with Ruby 3.2.2 and Rails 7.1.2
- [Redis](https://redis.io/) 6.2+ (for Sidekiq)
- [libvips](https://www.libvips.org/) (for image processing)

## Configuration

Set up your environment variables based on the `.env.template` file.

```sh
cp .env.template .env
```

Production environment variables should be set in the hosting environment.

## Development startup

Rails server and Sidekiq worker (Redis has to be running) can be started with the following commands. 

There is a demo user with the following credentials: `email: demo@example.com`, `password: password`.

```sh
bundle install
rails db:create db:migrate
rails db:seed
rails s
```

```sh
bundle exec sidekiq
```
