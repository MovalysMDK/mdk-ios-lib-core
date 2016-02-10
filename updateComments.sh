#!/bin/bash

# supprime le tag Created by
find MFCore \( -name "*.m" -o -name "*.h" \) -exec sh -c 'sed "/Created by/d" "$1" > "$1".tmp && mv "$1".tmp "$1"' _ {} \;

#supprime le tag Copyright (c)
find MFCore \( -name "*.m" -o -name "*.h" \) -exec sh -c 'sed "/Copyright (c)/d" "$1" > "$1".tmp && mv "$1".tmp "$1"' _ {} \;
