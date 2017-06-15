[![Build Status](https://travis-ci.org/jpbonson/UserSegmentationAPI.svg?branch=master)](https://travis-ci.org/jpbonson/)

# User Segmentation API

API that allows the segmentation of users according to custom filters.

Ruby. Grape. MongoDB.

[WORK IN PROGRESS (see TODO and REFERENCES in the main directory)]

# Installation

```
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

# Examples

```
curl -v http://localhost:9999/api/v1/users/annie
```

```
curl -v -H "Content-Type: application/json" -X POST -d '{"id": "annie", "email":"annie@email.com", "name":"Annie A.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users
```

```
curl -v -H "Content-Type: application/json" -X PUT -d '{"id": "annie", "email":"annie@email.com", "name":"Annie B.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users/annie
```

```
curl -v -X "DELETE" http://localhost:9999/api/v1/users/annie
```

```
curl -v http://localhost:9999/api/v1/users
```
