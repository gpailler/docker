#!/bin/bash
set -e

image="$1"

cd .examples/dockerfiles

dirs=( */ )
dirs=( "${dirs[@]%/}" )
for dir in "${dirs[@]}"; do
    if [ -d $dir/$VARIANT ]; then
        (
            cd $dir/$VARIANT
            sed -ri -e 's/^FROM .*/FROM '"$image"'/g' 'Dockerfile'
            travis_retry docker build -t "$image-$dir" .
            ~/official-images/test/run.sh "$image-$dir"
        )
    fi
done
