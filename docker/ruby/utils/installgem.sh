#!/bin/sh

set -x

gem install --install-dir /build/ruby $SOURCE

mv /build/ruby/gems/psych-$VERSION /build/ruby/gems/psych
