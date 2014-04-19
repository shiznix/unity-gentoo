#!/bin/bash

# Fetches any new changes from the original repository
git fetch upstream
# Merges any changes fetched into your working files
git merge upstream/master
