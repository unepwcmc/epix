# EPIX Conduit

This repository contains the source code of the EPIX project. The EPIX (Electronic Permit Information eXchange) facilitates and expedites the exchange of permit data among national CITES Authorities.

## Installation

EPIX is a Rails 4 app, using a Postgres database. Installation is pretty standard:

```
  $ git clone https://github.com/unepwcmc/epix
  $ cd epix
  $ bundle install
  $ bundle exec rake db:create db:migrate
  …

  $ bundle exec rails server
  …
```

Visit `http://localhost:3000` and you should be good to go! 🎉

# License

This repository lives under the [MIT license.](LICENSE)
