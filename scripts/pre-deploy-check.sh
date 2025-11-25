#!/bin/bash
[ -f "static/CNAME" ] || exit 1
hugo || exit 1
[ -d "public" ] && [ -n "$(ls -A public)" ] || exit 1
