# Introduction

This project is the code for paper: **SAH: Fine-grained RFID Localization with Antenna Calibration (INFOCOM2022)**.



# Getting started

### Environment settings:

- Matlab R2019b
- Windows10

### Data collection

The data can be collected with an IMPINJ R420 RFID reader. The file format is as follows:

```
TimeStamp(ms)  epc        phase   max rssi   frequency   port
8663           20220106   5.375   -46.5      920.625     1
8668           20220106   5.405   -46.5      920.625     1
```
One dataset is provided here for reproduction:

**calibration:**

Two trajectories with a length of 1.2m are used. The moving direction is along the lateral direction, at the speed of 5cm/s. The radial distances are **60cm and 70cm**, respectively. 

localization:
The ground truth is **(100,100)cm** and the tag's motion trajectory is 1.5m long. The moving direction is along the lateral direction, at the speed of 5cm/s.

### Antenna calibration

You can run the script named **SAHCali.m** to calibrate the antenna with the given data of two trajectories. The calibration results will be saved in **calibration_results.mat**.

Results:

```
Calibration results of trajectories with 60 and 70cm radial distance.
Pixel Value: 4.02 
PO: 0.0276 rad 
PC: -4.40 -4.00 -17.40 cm 
```

### Tag localization

After calibration, you can run the script named **SAHLoc.m** to do the localization. 

results:

```
Position:
 x:100.95cm y: 99.430cm 

Localization error:
 x: 0.95cm y: -0.57cm combined: 1.11cm 
```


# Project description

### Project Structure

```
SAH
│  README.md
│  
├─data
│  ├─calibration
│  │      cali_channel1_dist60.txt
│  │      cali_channel1_dist70.txt
│  │      
│  └─localization
│          Loc_100_100.txt
│          
└─src
    │  SAHCali.m
    │  SAHLoc.m
    │  
    └─func
            CaliPixel.m
            Cal_trj.m
            LocPixel.m
            Sampling.m
```

