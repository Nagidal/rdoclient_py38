JSON-RPC-Python3
================

RANDOM.ORG JSON-RPC API (Release 2) implementation.

This is a Python 3 implementation of the RANDOM.ORG JSON-RPC API (Release 2).
It provides either serialized or unserialized access to both the signed
and unsigned methods of the API through the ``RandomOrgClient`` class.
It also provides a convenience class through the ``RandomOrgClient``
class, the ``RandomOrgCache``, for precaching requests. In the context
of this module, a serialized client is one for which the sequence of
requests matches the sequence of responses.

Installation
------------

To install, simply: ``pip install rdoclient-py3`` after you set up
a virtual environment (eg, with ``virtualenvwrapper``):

``mkvirtualenv --python=/usr/local/bin/python3.6 rdoclient-py3``

The base RDO implementation only requires the
`requests <http://docs.python-requests.org/en/latest/>`__ library:
``pip install requests``. However, this package (``rdoclient-py3``)
requires additional dependencies:

``pip install pytest``

Tests
-----

Secure an API key and run the tests. Note that to run the accompanying tests
the API\_KEY fields must be given authentic values. Get an API key from
`here <https://api.random.org/api-keys>`__.

Set ``_API_KEY_1`` equal to your API key, and leave ``_API_KEY_2`` equal to
something else.

Then run tests like so:

``py.test test_rdoclient.py``

Usage
-----

The default setup is best for non-time-critical serialized requests, eg,
batch clients:

::

    >>> from rdoclient_py3 import RandomOrgClient
    >>> r = RandomOrgClient(YOUR_API_KEY_HERE)
    >>> r.generate_integers(5, 0, 10)
    [6, 2, 8, 9, 2]

...or for more time sensitive serialized applications, eg, real-time
draws, use:

::

    >>> r = RandomOrgClient(YOUR_API_KEY_HERE, blocking_timeout=2.0, http_timeout=10.0)
    >>> r.generate_signed_integers(5, 0, 10)
    {'random': {u'min': 0, u'max': 10, u'completionTime': u'2014-05-19 14:26:14Z', u'serialNumber': 1482, u'n': 5, u'base': 10, u'hashedApiKey': u'HASHED_KEY_HERE', u'data': [10, 9, 0, 1, 5], u'method': u'generateSignedIntegers', u'replacement': True}, 'data': [10, 9, 0, 1, 5], 'signature': u'SIGNATURE_HERE'}

If obtaining some kind of response instantly is important, a cache
should be used. A cache will populate itself as quickly and efficiently
as possible allowing pre-obtained randomness to be supplied instantly.
If randomness is not available - eg, the cache is empty - the cache will
return an Empty exception allowing the lack of randomness to be handled
without delay:

::

    >>> r = RandomOrgClient(YOUR_API_KEY_HERE, blocking_timeout=60.0*60.0, http_timeout=30.0)
    >>> c = r.create_integer_cache(5, 0, 10)
    >>> try:
    ...     c.get()
    ... except Queue.Empty:
    ...     # handle lack of true random number here
    ...     # possibly use a pseudo random number generator
    ...
    [1, 4, 6, 9, 10]

Note that caches don't support signed responses as it is assumed that
clients using the signing features want full control over the serial
numbering of responses.

Finally, it is possible to request live results as-soon-as-possible and
without serialization, however this may be more prone to timeout
failures as the client must obey the server's advisory delay times if
the server is overloaded:

::

    >>> r = RandomOrgClient(YOUR_API_KEY_HERE, blocking_timeout=0.0, http_timeout=10.0, serialized=False)
    >>> r.generate_integers(5, 0, 10)
    [3, 5, 2, 4, 8]

Documentation
-------------

For a full list of available randomness generation functions and other
features see ``rdoclient.py`` documentation and
`this link <https://api.random.org/json-rpc/2>`__.

Change log
----------

See `this link <https://packaging.python.org/tutorials/distributing-packages/#pure-python-wheels>`__ for packaging documentation.

* 2019-08-21 Release 2.0.6: Updated API Endpoint to use v2
* 2018-04-10 Release 2.0.5: Fixed Python 3.5 compatibility for exception errors
* 2018-02-11 Release 2.0.3: Improved README and fixed tests
* 2017-12-06 Release 2.0.2: Obfuscated API in logging output
* 2017-07-15 Release 2.0.1: Converted README.md to RST for PyPi
* 2017-07-15 Release 2.0.0: Initial release. Added to PyPi
