#!/usr/bin/env bash
git add . && \
git add -u && \
git commit -m "$(read -p 'Commit description: ')" && \
git push origin HEAD