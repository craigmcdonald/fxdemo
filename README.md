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
Return the exchange rate (as a Float) between a base and counter currency:
```
Frgnt::Exchange.at(Date.today,'USD','GBP')
```
Passing true at the end of the args will force the method to recurse until it finds a valid date (useful for weekends, etc).
By default it will try 10 previous dates (although this can be overriden by passing in an integer other than 10), e.g.:
```
Frgnt::Exchange.at(Date.today,'USD','GBP',true,42)
```

# Demo App

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
3. The launch the app ```rackup```

## To-Do

1. Fix the JavaScript tests (right now the snapshots fail because moment() needs to be mocked)
2. Create a deployment strategy for production (i.e. write a Procfile)
