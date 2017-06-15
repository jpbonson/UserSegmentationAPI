[![Build Status](https://travis-ci.org/jpbonson/UserSegmentationAPI.svg?branch=master)](https://travis-ci.org/jpbonson/) [![Coverage Status](https://coveralls.io/repos/github/jpbonson/UserSegmentationAPI/badge.svg?branch=master)](https://coveralls.io/github/jpbonson/UserSegmentationAPI?branch=master)

# User Segmentation API

API that allows the segmentation of users according to custom filters.

Ruby. Grape. MongoDB.

[WORK IN PROGRESS (see TODO and REFERENCES in the main directory)]

# Installation

```
sudo apt-get install mongodb
bundle install
```

# Execution

```
bundle exec rackup config.ru -p 9999
```

# Tests

```
bundle exec rake
```

# Examples (current code)

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
curl -v http://localhost:9999/api/v1/users?state=SC&age=30
```

```
curl -v http://localhost:9999/api/v1/users?state=SC&age=30&logic_op=or
```

# Examples (Heroku)

Obs.: I am getting 'HTTP/1.1 503 Service Unavailable' when trying to use mongodb by the mongolab addon. I guess the DB wasn't up yet. So I deployed at Heroku with an older version of the code (commit 4185b8820682f82523d8b17b97bc1c19cd0a7444).

```
curl -v https://mighty-scrubland-86456.herokuapp.com/api/v1/users/annie
```

```
curl -v -H "Content-Type: application/json" -X POST -d '{"id": "annie", "email":"annie@email.com", "name":"Annie A.", "age": 30, "state": "SC", "job": "dev"}' https://mighty-scrubland-86456.herokuapp.com/api/v1/users
```

```
curl -v -H "Content-Type: application/json" -X PUT -d '{"id": "annie", "email":"annie@email.com", "name":"Annie B.", "age": 30, "state": "SC", "job": "dev"}' https://mighty-scrubland-86456.herokuapp.com/api/v1/users/annie
```

```
curl -v -X "DELETE" https://mighty-scrubland-86456.herokuapp.com/api/v1/users/annie
```

```
curl -v https://mighty-scrubland-86456.herokuapp.com/api/v1/users
```
