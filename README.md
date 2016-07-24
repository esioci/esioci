esioci
=====

An OpenSource Continuous Integration software

[![Build Status](https://travis-ci.org/esioci/esioci.svg?branch=master)](https://travis-ci.org/esioci/esioci)
[![Coverage Status](https://coveralls.io/repos/github/esioci/esioci/badge.svg)](https://coveralls.io/github/esioci/esioci)

Requirements
-----
* Elixir 1.2.6

Build
-----
    $ mix compile

Run UnitTests
-----
    $ mix coveralls
Run
-----
    $ iex -S mix run

Create database schema
-----
    mix ecto.create

Migrate
----
    mix ecto.migrate

How to use esioci:
----
Create initial db data (project default)

    mix run priv/repo/seeds.exs

CONFIGURATION
Set env variable API_PORT to configure port.

## How To Use
### Installation
1. Download source code
2. Edit config/config.exs
3. Create database
4. Run migration `mix ecto.migrate`
5. Seed database `mix run priv/repo/seeds.exs`
6. Run application `screen iex -S mix run`
7. Configure github webhook and point it to `address:port/api/v1/default/bld/gh`

ROADMAP
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
