require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)
Dotenv.load unless ENV['RACK_ENV'] == 'production'
require File.expand_path('../app/app',__FILE__)

run FrgntApp
