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
rackup config.ru -p 9999
```

# Tests

[TODO]

# Examples

```
curl -v http://localhost:9999/api/v1/users/annie
```

```
curl -v -H "Content-Type: application/json" -X POST -d '{"id": "annie", "email":"annie@emailcom", "name":"Annie A.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users
```

```
curl -v -H "Content-Type: application/json" -X PUT -d '{"id": "annie", "email":"annie@emailcom", "name":"Annie B.", "age": 30, "state": "SC", "job": "dev"}' http://localhost:9999/api/v1/users/annie
```

```
curl -v -X "DELETE" http://localhost:9999/api/v1/users/annie
```
