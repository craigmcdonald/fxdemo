# Fx Library

## Set-up

Call the `config` method on `Frgnt::Store` to set the initial config details:
```
Frgnt::Store.config do |secret|
 set_store :redis, secret
 set_base 'EUR'
 logger Logger.new('<path/to/log/file>',5, '9C4000'.hex)
end
```
There are currently two available stores `:memory` and `:redis`.  The latter requires a secret (or any unique-ish string).

## Fetching updated exchange rates

Fetch from the [ECB](http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml):
```
Frgnt::Store.fetch
```
Fetch from a local XML file:
```
Frngt::Store.fetch_from_file(<filepath>)
```

## Using the library

Return a sorted list of all available currencies:

```
Frgnt::Store.list
```
Get the exchange rate (as a `Float`) between a base and counter currency:
```
Frgnt::Exchange.at(Date.today,'USD','GBP')
```
1. The method will either accept a `Date` or a string that parses to a valid date (e.g. '2001-01-01').
2. The 2nd and 3rd args need to be valid ISO 4217 codes (e.g. 'USD' or 'GBP').
3. Passing true at the end of the args will force the method to recurse until it finds a valid date (useful for weekends, etc). By default it will try 10 previous dates (although this can be overriden by passing in an integer other than 10), e.g.:
```
Frgnt::Exchange.at(Date.today,'USD','GBP',true,42)
```

# Demo App
The demo app uses Sinatra and React (which is not a combination I'd thought of doing before, but I'd previously come across a gem that attempted to meld the two and I figured I may was well try it since React and Rails is now all the rage). It has a few rough edges, specifically around Server-Side Rendering, which was the basic motivation for trying this in the first place.  However, the concept is (fairly) sound.

## Prerequisites

1. Ruby 2.4.1 (I personally use [rbenv](https://github.com/rbenv/rbenv) to manage ruby versions)
2. [Node](https://nodejs.org/en/)
3. [Yarn](https://yarnpkg.com/lang/en/docs/install/) (or you can use npm)
4. [Redis](https://redis.io/)

## Set-up

1. Clone the repo
2. In the root of the app, run ```bundle install```
3. Then install all JavaScript dependencies: ```cd client && yarn install && cd -``` (if you are using npm  then run `npm install`)

## Running the app in development

1. Start redis (`redis-server`)
2. Build the JavaScript client: ```cd client && npm run build && npm run build-server && cd-```
3. Launch the app ```rackup```
4. Go to ```http://localhost:9292/```

## To-Do

1. Fix the JavaScript tests (right now the snapshots fail because `moment()` needs to be mocked)
2. Fix Server-Side Rendering (it is undoubtedly just a simple bug, albeit `ExecJS` makes it painful to figure out what it is).
3. Create a deployment strategy for production (i.e. write a Procfile)
