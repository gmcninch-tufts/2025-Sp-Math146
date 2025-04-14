#!/usr/bin/env bash

echo "deploying math146-2025Sp-site"
cd /home/george/Prof-VC/classes/2025-Sp-Math146/
git add .
read -p "Commit message: " msg
git commit -m "$msg"
git push origin main
