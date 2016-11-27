# Currency Tracker

![build status](https://travis-ci.org/gabrielssilva/currency-tracker.svg?branch=master)

This app shows a chart with the seven last days of ARS, USD, and EUR currency rates, taking the BRL currency as base.

## Running your own installation

To run the Currency Tracker, you will need Ruby 2.3.0 (maybe it will work with older versions, but no guarantees!). You probable also want to use something like RVM.

If you do not have bundler:

```
$ gem install bundler
```

Go ahead and install all dependencies.

```
$ bundle install
```

The last step is to export your Currency Layer (former jsonrates) API key to a system environment variable. If you do not have one, you can register free at [their website](https://currencylayer.com/). If you are using a Unix like system:

```
$ export CURRENCY_LAYER_API_KEY=<your secrect API key>
```

And then you are good to go :)

```
$ bundle exec rails server
```

## Running Tests

```
$ bundle exec rake tests
```
