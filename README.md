# Graduation Thesis: Smart Home Automation

## Overview

Welcome to the repository for the Graduation Thesis project on Smart Home Automation. This project leverages the ESP32 microcontroller for hardware communication and the Flutter framework for the user interface. The aim is to create a comprehensive smart home solution that allows users to control and monitor various devices remotely.

![Smart Home Automation](https://kete-rvs.com/wp-content/uploads/2020/02/smart-home-3.jpg)

## Features

- **Device Control:** Remotely control and monitor smart devices such as lights, thermostats, and more using the mobile app.

- **Real-time Updates:** Receive real-time updates on the status of your devices to ensure accurate and timely information.

- **User-friendly Interface:** The Flutter-based mobile app provides an intuitive and user-friendly interface for seamless interaction with the smart home system.

- **ESP32 Integration:** ESP32 microcontrollers are employed for device communication, ensuring a reliable and efficient connection between devices and the mobile app.

## Technologies Used

- **ESP32:** Microcontroller platform for device communication and control.

- **Flutter:** Cross-platform framework for building the mobile app.


## Getting Started

### Prerequisites

- Arduino IDE for ESP32 programming.
  
- Flutter SDK for mobile app development.
  
- MQTT Broker (e.g., Mosquitto) for communication between devices and the app.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/jehato47/Graduation-Thesis-Smart-Home-Automation.git

2. Set up ESP32 devices using the Arduino IDE.

3. Configure the Flutter app to connect to your MQTT broker.

4. Build and deploy the mobile app to your device


## Usage

1. Ensure the ESP32 is connected to the WiFi network.

2. The firmware periodically sends data to the Firebase Realtime Database and checks for device states.

3. Monitor the ESP32 serial output for debugging information.

## Functions

- `pushJsonWithId()`: Pushes JSON data to the Firebase Realtime Database with a unique ID.

- `getTime()`: Retrieves the current time from an NTP server.

- `checkVariables()`: Retrieves and checks variables from the Firebase Realtime Database.

- `setLedBrightness(int brightness)`: Sets the LED brightness based on a value from the Firebase Realtime Database.

- `uploadSensorValues()`: Uploads sensor values (light and gas) to the Firebase Realtime Database.

- `readSensors()`: Reads sensor values from connected sensors.

## Acknowledgments

- The firmware uses the [Firebase ESP Client Library](https://github.com/mobizt/Firebase-ESP-Client) for communication with the Firebase Realtime Database.

- Special thanks to **Jehat Armanç Deniz** and **Tuğba Göven** for their contributions to the development and implementation of the ESP32 firmware.
