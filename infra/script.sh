#!/bin/bash

wget https://raw.githubusercontent.com/GoldenRed/K-TWSTP/master/src/app.py
sudo apt-get install python3-flask
sudo nohup python3 app.py &
