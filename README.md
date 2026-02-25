# Geo Fields

A Ruby On Rails based  SPA for managing agricultural fields. 
Users can draw field outlines on an interactive map powered by Leaflet ; 
the app stores multi-polygon geometry in PostGIS and calculates area automatically
with checking for overlap, containment and crossing conflicts with existed field outlines.

<img width="1421" height="616" alt="image" src="https://github.com/user-attachments/assets/d8023ef9-5187-4004-be0f-385175fbc98d" />


## Tech Stack

- Ruby 3.2.1 / Rails 8
- PostgreSQL + PostGIS (spatial data)
- Leaflet.js + Leaflet.draw (map interaction)
- Stimulus / Turbo (HotWire)
- Bootstrap (styling)
- Docker / Docker Compose

## Getting Started

### With Docker (recommended)

```bash
docker-compose up --build
docker-compose run web rails db:create db:migrate
docker-compose run web rails db:seed   # optional sample data

docker-compose down # stop containers
```

The Geo Fields app. will be available at `http://localhost:3000`.

### Local setup (to run outside of Docker)

Requires Ruby 3.2.1 and a running PostgreSQL instance with the PostGIS extension.

```bash
rvm use 3.2.1
bundle install
rails db:create db:migrate
rails server
```

## Features

- Draw and edit field polygons on a map (multi-polygon support)
- Automatic area calculation via PostGIS `ST_Area`
- Index view shows all fields on a shared map
- Detail view fits the map to the selected field's bounds
- JSON API endpoints with Client ID / Client Secret authentication

## Running Tests

```bash
bundle exec rspec
```

## Linting

```bash
rubocop -a            # Ruby
eslint app/javascript --fix  # JavaScript
```
