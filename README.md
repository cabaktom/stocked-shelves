# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Ruby version

- built with Ruby 3.2.2 and Rails 7.1.2

## Dependencies

- Redis 6.2+ (for Sidekiq), [installation guide](https://redis.io/docs/install/install-redis/)

## Configuration

For local development set up the environment variables based on the `.env.template` file.

```sh
cp .env.template .env
```

Production environment variables should be set in the hosting environment.
