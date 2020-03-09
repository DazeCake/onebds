#!/bin/bash
screen_name=$"bds"
cmd=$"LD_PRELOAD=./preload.so ./bedrock_server";
         screen -x -S $screen_name -p 0 -X stuff "cd bds"
         screen -x -S $screen_name -p 0 -X stuff $'\n'
         screen -x -S $screen_name -p 0 -X stuff "$cmd"
         screen -x -S $screen_name -p 0 -X stuff $'\n'
         screen -R $screen_name
