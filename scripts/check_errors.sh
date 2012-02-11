#!/bin/bash

grep --color=always -rn "Liquid syntax error" _site/
grep --color=always -rn "Included file '" _site/
