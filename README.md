#esioci

EsioCi is an OpenSource Continuous Integration software

[![Build Status](https://travis-ci.org/esioci/esioci.svg?branch=master)](https://travis-ci.org/esioci/esioci)
[![Coverage Status](https://coveralls.io/repos/github/esioci/esioci/badge.svg)](https://coveralls.io/github/esioci/esioci)

## Requirements
* Elixir >= 1.2
* OTP 19
* PostgreSQL database

## How To Use
### Installation and Configuration
1. Download source code
2. Edit config/config.exs
  1. Set api port
  2. Configure database
3. Create database
4. Run migration `mix ecto.migrate`
5. Seed database `mix run priv/repo/seeds.exs`
6. Run application `screen iex -S mix run`
7. Configure github push webhook and point it to `address:port/api/v1/default/bld/gh`

### API endpoints

#### GET api/v1/project_name/bld/last
Returns json with last build status for project: project_name

#### POST api/v1/project_name/bld/gh
Run github project

## How To Develop
### Run app first time
1. get dependencies `mix deps.get`
2. compile `mix compile`
3. Create database `mix ecto.create`
4. Migrate database `mix ecto.migrate`
5. Seed database `mix run priv/repo/seeds.exs`
6. run `iex -S mix run`

### Unit tests
1. Run unit tests and generate html coverage report `mix coveralls.html`
2. Coverage html report in cover directory

## ROADMAP
-----
- Version 0.1
    + SCM systems:
        * ~~[DONE] support for GIT~~
    + Build:
        * ~~[DONE] Run build only on server~~
    + Build configuration file:
        * ~~[DONE] All build configuration in esioci.yaml~~
        * ~~[DONE] exec() - run basic shell commands~~
    + REST:
        * run build using webhook
            - ~~[DONE] github~~
        * ~~[DONE] check last build status~~
    + ~~[DONE] CI in esioci~~
- Version 0.2
    + Build configuration file:
        * artifacts() - store artifacts specified directory
    + REST:
        * get_artifacts
        * CRUD for projects, add support for multiple projects in one instance
- Version 0.3
    + Build:
        * Run on distributed nodes
    + Build configuration file:
        * Run on specified node
- Version 0.4
    + Build:
        * Distributed nodes have properties
    + Build configuration file:
        * Node properties support, e.g. run on node with attribute, OS, etc.
- Version 0.5
    + Build:
        * parallel builds
    + Build configuration file:
        * add supports for multiple steps, parallel, sequential, etc.
    + REST:
        * get build steps map

Authors
-----
Grzegorz "esio" Eliszewski - http://esio.one.pl
