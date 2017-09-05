#!/bin/sh

file_name="cd-guidelines-$(git describe --abbrev=0 --tags)-$(date +'%Y%m%d-%H%M%S')"

mkdir -p build

gitbook pdf . build/${file_name}.pdf
