# scorecard-web

[![Maintainability](https://api.codeclimate.com/v1/badges/e67cf3b60e1040934010/maintainability)](https://codeclimate.com/github/kakada/scorecard-web/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e67cf3b60e1040934010/test_coverage)](https://codeclimate.com/github/kakada/scorecard-web/test_coverage)

The scorecard-web is a community scorecard web application and backend API for [scorecard_mobile](https://github.com/ilabsea/scorecard_mobile) Application.

## Development Setup
### System dependencies

Scorecard-web is a standard Rails application, and it also needs the following services to run:
- PostgreSQL: 12.4
- Docker
- Docker Compose

### Configuration
In ```app.env``` file: copy content in ```app.env.example``` to the file

1. To enable feature **Sign in with Google**:
The Client ID obtained from the [Google Console](https://developers.google.com/maps/documentation/maps-static/get-api-key). Replace with your own Client ID and Client Secret

```
GOOGLE_CLIENT_ID=client_id
GOOGLE_CLIENT_SECRET=client_secret
```
2. To enable feature **Sentry logger**:
Signup with sentry.io to get SENTRY_DSN and replace the URL
```
SENTRY_DSN=url
```

## Installation
- Install [Docker](https://docs.docker.com/get-docker/)
- install [Docker Compose](https://docs.docker.com/compose/install/)

## Docker development
```docker-compose.yml``` file builds a development environment mounting the current folder and running rails in a development environment.

Run the following commands to have a stable development environment.
```
$ docker-compose run --rm web bundle
$ docker-compose run --rm web rake db:dev
$ docker-compose up
```
And visit [localhost:3000](localhost:3000)

To set up and run the test, run
```
$ docker-compose run --rm web rspec
```

To run lint
```
$ docker-compose run --rm web rubocop
```
