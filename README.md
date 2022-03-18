# README

rbenv install <version>

bundle install

bundle exec rake db:create

# Plans

Use ActionCable with Vue, on the not-that-confident assumption that Vue is better suited to something that, like a game, wants the game state all over the page, rather than encapsulated in little controllers that don't know about each other (recalling 2020 experience with Stimulus.)

Continue following guide from this point: https://guides.rubyonrails.org/action_cable_overview.html#subscriber




## NOTA BENE

I'm getting the vibe that actioncable/websockets are not going to play nice with Turbo(links): https://stackoverflow.com/questions/38649550/rails-how-to-disable-turbolinks-in-rails-5

Also, websockets sounds like a piece of crap:

> The same is especially true for WebSocket updates. On poor connections, or if there are server issues, your WebSocket may well get disconnected. If the application is designed to work without it, it’ll be more resilient.

(From [Turbo docs](https://turbo.hotwired.dev/handbook/streams).)

I don't want an application designed to work without websockets. I want one that works nicely.






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
