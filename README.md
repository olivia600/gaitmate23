# GaitMate
Senior design project for utilizing sensor in a custom lower limb exoskeleton to track gait improvement in post-stroke survivors

## Description

This project encompasses a lower limb exoskeleton intended for use by post-stroke survivors exhibiting hemiparalgia. The exoskeleton is composed of sensors to monitor the gait of the user, allowing the user and caregiver to track progress and improvement of the user's gait. The exoskeleton has 3 MPU-6050 modules to measure acceleration and gyroscopic data and a pressure sensing mat to determine the distributed load on the user's foot at different stages of the gait. The sensors are managed with a Arduino Giga R1 Wifi microcontroller.

The MPU-6050 modules help the user to determine their knee and ankle joint angles. The acceleration and gyroscopic data are processed through a Gauss-Newton algorithm with the Jacobi method to live transform data into joint angle information. This data is transmitted to a companion iOS app on an iPhone via serial communication over BLE for easy viewing of live data.

## Features

List the key features of your project.

- Arduino Code (Exoskeleton.ino)
- iOS Companion App (GaitMateApp)

## References
[1] IMU-Based Joint Angle Measurement for Gait Analysis: https://doi.org/10.3390/s140406891

[2] imu-based-joint-angle-measurement: https://github.com/kimkimyoung/imu-based-joint-angle-measurement

[3] Pressure Sensing Mat Wiring Diagram: https://ibb.co/10wK7Jy
