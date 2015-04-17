# README

## Setup the runtime environment

1. Ensure that you are using Python 2.7
```
python --version
> Python 2.7.x
```
2. Install the necessary dependencies
```
pip install matplotlib colorama
```

## Run tests

1. Create the map you want to use and name it `[something]env.png` or use the default `env.png`.
2. Run iCLAP.py and specify your initial conditions or use the defaults.
```
python iCLAP.py
```
3. View the results in the comma-separated-value (.csv) files.
  * You can view them in Excel

## Visualize the results

1. Run the Matlab script graph_voronoi.m
2. Edit the script to point to the correct files if necessary
  * Line 1 should point to `state_log.csv`
