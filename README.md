# AP ELECTION LOADER
Relies on [Elex](https://github.com/newsdev/elex), a command-line tool to get results from the AP Election API 2.0. Demonstrates a method putting those results into a Postgres database using the COPY method and the loader's CSV output.

## Assumptions
The following things are assumed to be true in this documentation.

* You are running OSX.
* You are using Python 2.7. (Probably the version that came OSX.)
* You have pip, [virtualenv](https://pypi.python.org/pypi/virtualenv) and [virtualenvwrapper](https://pypi.python.org/pypi/virtualenvwrapper) installed and working.

See "Chapter 2: Install Virtualenv" of NPR's [development environment blog post](http://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html) for details.

Having trouble on OS X El Capitan? See: [Can't install virtualenvwrapper on OSX 10.11 El Capitan](http://stackoverflow.com/questions/32086631/cant-install-virtualenvwrapper-on-osx-10-11-el-capitan).

## Getting started
```
./scripts/$ENV/bootstrap.sh
```

The `bootstrap.sh` script will create databases and the user necessary for local development. Note: This does not exist for non-development environments. Please use commands in [elex-dotfiles](https://github.com/newsdev/elex-dotfiles) instead.

## Environments

The New York Times defines a handful of different environments; principally, `dev`, `stg` and `prd`.

* `dev`: Hits test URLs by default. Assumes a local Postgres database where the local user is a superuser.
* `stg`: Hits test URLs by default. Requires a Postgres user / host / password to be defined in the environment. We use a `.pgpass` file and export the rest in `/etc/environment`. Check out [elex-dotfiles](https://github.com/newsdev/elex-dotfiles) for more.
* `prd`: Hits live URLs by default. Requires a Postgres user / host / password to be defined in the environment.

## Use cases

### Load initial data
```bash
./scripts/$ENV/reload.sh
```

The AP will make "live zeros" available in the morning of an election day. You can run `reload.sh` to get an entire new set of data, including races, reporting units, candidates and zeroed-out results.

### Load results on election night
```bash
./scripts/$ENV/daemon.sh
```

The daemon will run 100,000 times (seriously) unless it is stopped. We control ours with https://github.com/newsdev/supervisor and a custom `/etc/supervisord.conf`. This configuration file is available in [elex-dotfiles](https://github.com/newsdev/elex-dotfiles) along with other secrets.

#### Set a wait interval
You might want to control how long the daemon waits between cycles. This is hardcoded to a default -- 15s in production, 30s elsewhere. You can create the file `/tmp/elex_loader_timeout.sh` and export an `ELEX_LOADER_TIMEOUT` variable like this:

```bash
export ELEX_LOADER_TIMEOUT=60
```

The daemon checks for this file and sources it if it exists in every loop, which means you can dynamically control the wait time. For example, we do this in [our admin](https://github.com/newsdev/elex-admin/blob/master/elex_admin/app.py#L294).

### Load results once
```bash
./scripts/$ENV/update.sh
```

Sometimes you just need to load a single 

### Load delegate data
```bash
./scripts/$ENV/delegates.sh
```