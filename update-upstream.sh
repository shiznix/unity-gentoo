#!/bin/bash

# Fetches any new changes from the original repository
git fetch upstream
# Merges any changes fetched into your working files
git merge upstream/master

# git remote add shiznix git://github.com/shiznix/unity-gentoo.git

git pull shiznix master
