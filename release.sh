#!/usr/bin/env bash

# To release, bump version in `setup.py` and add release notes in `README.rst`
# Then run this script: `./release.sh`

python setup.py sdist
python setup.py bdist_wheel
twine upload dist/*