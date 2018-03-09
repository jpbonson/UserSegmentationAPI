[![Build Status](https://travis-ci.org/jpbonson/UserSegmentationAPI.svg?branch=master)](https://travis-ci.org/jpbonson/) [![Coverage Status](https://coveralls.io/repos/github/jpbonson/UserSegmentationAPI/badge.svg?branch=master)](https://coveralls.io/github/jpbonson/UserSegmentationAPI?branch=master)

# User Segmentation API

API that allows the segmentation of users according to custom filters.

Ruby. Grape. MongoDB.

### How to install? ###

```
sudo apt-get install mongodb
rvm install "ruby-2.4.0"
gem install bundler
bundle install
```

### How to run? ###

```
bundle exec rackup config.ru -p 9999
```

### How to test? ###

```
bundle exec rake
```

### API Routes ###

## Users

```
curl -v http://localhost:9999/api/v1/users/annie
```

```
curl -v -H "Content-Type: application/json" -X POST -d '{"_id": "annie", "email":"annie@email.com", "name":"Annie A.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users
```

```
curl -v -H "Content-Type: application/json" -X PUT -d '{"_id": "annie", "email":"annie@email.com", "name":"Annie B.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users/annie
```

```
curl -v -X "DELETE" http://localhost:9999/api/v1/users/annie
```

```
curl -v http://localhost:9999/api/v1/users
```

```
curl -v "http://localhost:9999/api/v1/users?state=SC&age=30"
```

```
curl -v "http://localhost:9999/api/v1/users?state=SC&age=30&logic_op=or"
```

```
curl -v "http://localhost:9999/api/v1/users?state=SC&age=30&logic_op=or&age_op=gte"
```

```
curl -v "http://localhost:9999/api/v1/users?job_regex=dev\z"
```
