require './main'

run Rack::Cascade.new [UserSegmentation::API]
