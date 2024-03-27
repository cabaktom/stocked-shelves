# StockedShelves

A [Ruby on Rails](https://rubyonrails.org/) web application for keeping track of all the food you have. The app allows you to create products which represent the food you most often buy. Based on the products you can create items which represent the food you have in your home at the time with the actual quantity and expiration. To keeps things organized, you create colored lists and add items to them. If you wish so, you can receive email notifications keeping you updated on the expiration of your items.

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

1. Start the PostgreSQL database with the following command:

```sh
docker compose up -d db
```

2. For the Sidekiq worker to work, Redis has to be running and can be e.g. started with the following command:

```sh
sudo service redis-server start
```

3. Sidekiq worker then can be started with the following commands:

```sh
bundle exec sidekiq
```

4. Lastly, start the Rails server with the following commands:

```sh
bundle install
rails db:create db:migrate
rails db:seed
rails server
```

There is a demo user created by the `db:seed` command with the following credentials: `email: demo@example.com`, `password: password`.

The server will be available on `http://localhost:3000/` and the Sidekiq web UI on `http://localhost:3000/sidekiq`.

## Test suite

Run the test suite with the following command:

```sh
rake test
```

Rake is used instead of Rails because Rails ignores the Rake task in the `lib/tasks` directory which sets up the test environment, including the database.
