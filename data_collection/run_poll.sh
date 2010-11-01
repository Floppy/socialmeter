#!/bin/bash 
while [ 1 ]; do
  php pachube_poll_carbon.php
  sleep 10
done
