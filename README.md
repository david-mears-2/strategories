# README

rbenv install <version>

bundle install

bundle exec rake db:create
## WebSockets

I'm getting the vibe that actioncable/websockets are not going to play nice with Turbo(links): https://stackoverflow.com/questions/38649550/rails-how-to-disable-turbolinks-in-rails-5

Also, websockets (or WS in Rails?) sounds like a piece of crap:

> The same is especially true for WebSocket updates. On poor connections, or if there are server issues, your WebSocket may well get disconnected. If the application is designed to work without it, it’ll be more resilient.

(This was the case when I made Game of Cups - clients constantly disconnected.)

(From [Turbo docs](https://turbo.hotwired.dev/handbook/streams).)

I don't want an application "designed to work without" websockets. I want one that works nicely / as intended.

## Server Sent Events

Looked into these and came across [some](https://stackoverflow.com/questions/60637013/rails-app-hangs-when-theres-a-server-sent-event-sse-that-requires-database-ac?noredirect=1&lq=1) annoying [problems](https://github.com/rails/rails/issues/10989) which other people seem to have come across too. I don't think SSE are in very wide usage and I think Rails is not designed for them, and for both those reasons, I'm out.

I'm going to start doing this app with short-polling just to get something up and working. I can try and refine short-polling to long-polling or even to something better later. I'll keep turbolinks switched off so that the short-polling stops when we navigate pages.





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
