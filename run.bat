@echo off
title Lord Venkateswara Photo Reveal
echo ========================================================
echo Starting local web server for dynamic photo reveal...
echo ========================================================
echo Opening browser at http://localhost:8000
start http://localhost:8000
python -m http.server 8000
