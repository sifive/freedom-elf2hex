#!/bin/bash

mydirname=$(dirname "${BASH_SOURCE}")
exec "${mydirname}/../util/freedom-bin2hex" "$@"
