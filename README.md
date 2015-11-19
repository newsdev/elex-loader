# AP ELECTION LOADER
Relies on [the NYT/NPR AP election loader]() to get results from the AP API. Demonstrates a method putting those results into a Postgres database using the COPY method and the loader's CSV output.

## Getting started

The following things are assumed to be true in this documentation.

* You are running OSX.
* You are using Python 2.7. (Probably the version that came OSX.)
* You have pip, [virtualenv](https://pypi.python.org/pypi/virtualenv) and [virtualenvwrapper](https://pypi.python.org/pypi/virtualenvwrapper) installed and working.

See "Chapter 2: Install Virtualenv" of NPR's [development environment blog post](http://blog.apps.npr.org/2013/06/06/how-to-setup-a-developers-environment.html) for details.

### Install the software
```
git clone https://github.com/nprapps/ap-election-loader && cd ap-election-loader
mkvirtualenv ap-election-loader
pip install -r requirements.txt
```

### Export environment variables
```
export AP_API_KEY=<your API key>
```

See more [in the loader docs]().

### Run the loader
```
./init
./update
```
