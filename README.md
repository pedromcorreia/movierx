# MOVIERX

This application supports you to get all information about a valid genre.

The result is a compiled data from different Third Party APIs.

Each one has a different type of error, so here you will get the valid
data response.

## Decisions

#### 1. How to handle with different APIs and each one with different errors?

With the problem in downstream service, I tried different ways to always send better response:

1.1 I try to receive all information from the 3 APIs and off course, not good option;

1.2 My choice was, store all data in Postgres(or in this case, sqlLite), but in this case,
the time to store and read was really slow, so next!

1.3 Then I was thinking, how can I store fast and read faster? Ok, I will save on memory!
Some posts to understand:
https://schneems.com/post/20472425017/super-charge-your-rails-app-with-rack-cache-and

#### 2. Why I am not used Redis?

The best response here is, because I just need to save a simple data as small JSON, but there is a good opportunity to use Redis too.
https://aws.amazon.com/elasticache/redis-vs-memcached/

Memcached it is a good option to use with Dalli;
https://github.com/arthurnn/memcached
https://github.com/petergoldstein/dalli

#### 3. It woorks??

In my tests after 4-6 requests for each genre I started receive response without errors.

### Be careful using Memcached!
In my tests there was any problem to store all data in memory, but you need to watch you memory store to make sure the Memcached is not empty or full;

To flush https://www.cyberciti.biz/faq/linux-unix-flush-contents-of-memcached-instance/
In production you can use, Grafana or any other way to monitor.

## How to install?

First, sorry if my Dockerfile is not correct, but I cannot test the docker because mimemagic is not allowing to run:
https://www.reddit.com/r/rails/comments/md04cc/for_anyone_who_bumped_mimemagic_to_036_that/
https://github.com/rails/rails/issues/41750

1. Install [Ruby](https://www.ruby-lang.org/pt/downloads/);
2. I used sqlLite here to facilitate and not necessary use Postgres, so you don't need to install Postgres;
3. Install [Memcached](https://memcached.org/downloads);
4. Ensure that your Memcached is running, please, remember to change the  MEMCACHED key inside your .env.development file;
5. Then run `bundle install`;
6. Then run `rails db:setup` and if your seed file not runned, run: `rails db:seed`
7. Then run `rails s`;
8. Make sure that your Third Party APIs is running!

## How to run?

To make sure the API is working, you can run:

    curl --request GET \
      --url 'http://localhost:3000/movies?genre=Thriller&offset=0&limit=100'

You can use any valid genre in your search, just find them with:

    rails c
    Genre.all.pluck(:name)

## Tests?

I choose the rspec, so all tests is in /spec folder,
You can find the coverage with `open coverage/index.html` in your terminal, the current percentage is 100%.

## Production?

To run in production you need to create a .env.production with necessary keys, you can replicate the keys inside .env.develpment

# Contributing

To contribute, please follow some patterns:

-   Commit messages, documentation and all code related things in english;
-   Before open pull requests, make sure that  `rubocop` was executed;
