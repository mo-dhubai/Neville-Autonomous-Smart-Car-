Neville Smart Car
Wireless Control • Autonomous Navigation • Secure Biometric Access

A Pervasive Computing Project — Vrije Universiteit Amsterdam (Smart Systems Engineering, 2025)

Project Note: First successful Bluetooth-controlled Arduino Nano 33 IoT robot implementation at the VU Amsterdam Robotics Lab.

1. Introduction
The Neville Smart Car is an enhanced version of the VU Robotics Lab robot “Neville,” upgraded to support:

Face verification–based secure access

Wireless Bluetooth Low Energy (BLE) control

Dual operation modes: Autonomous line following and Manual remote control

Inspired by Tesla’s autonomous vehicle vision, this project merges computer vision, robotics, and pervasive computing into one fully functional prototype.

2. System Overview
Main Features
Face verification using MATLAB (HOG + SVM classifier)

BLE communication between MATLAB and Arduino Nano 33 IoT

PD-based autonomous line tracking

Manual driving via a custom MATLAB GUI

Real-time feedback, safety handling, and connection monitoring

3. Project Structure
MATLAB Components
captureImages.m – Automatic training photo capture

normalizeImage.m – Face detection, cropping, resizing

augmentTrainingData.m – Data augmentation

databaseNormalize.m – Batch normalization

createFaceClassifier.m – HOG + SVM training

verifyFace.m – Real-time verification

projectCounterance.mlapp – GUI interface

Arduino Components
neville_control.ino – Handles BLE commands and dual-mode logic

Automatic mode: PD line following

Manual mode: Forward/backward/left/right/stop control

4. Hardware Requirements
Arduino Nano 33 IoT

Pololu 3pi (or similar platform)

5 × reflective opto sensors

Laptop with Bluetooth support

Compatible power supply

5. Software Requirements
MATLAB R2025b

Computer Vision Toolbox

Bluetooth Toolbox

Instrument Control Toolbox

Communications Toolbox

App Designer

Arduino IDE

ArduinoBLE library

6. Functional Summary
Must-Have Features
Face detection & verification

BLE connection and safety disconnection handling

Autonomous mode:

Line tracking

Sensor calibration

T-junction handling

Manual mode:

Forward, backward, left, right, stop


7. Testing & Results
Face Verification Accuracy
85–90% in good lighting

60% in poor lighting

~75% with angular variation

Best threshold: 65% confidence

Bluetooth Connection
100% stability during active sessions

80–90% reconnection success on first attempt

Driving Performance
Autonomous mode: High reliability in line following

Manual mode: Instant command execution

8. Challenges & Solutions
Lighting variability → Addressed through extensive data augmentation

MATLAB–Arduino Bluetooth mismatch → Resolved via detailed documentation review

GUI development inexperience → Overcome using tutorials and App Designer guides

Dual-mode integration issues → Solved through staged debugging and incremental testing

9. Ethical Considerations
Face data stored locally only

System vulnerable to high-quality image spoofing

Not intended as a production-grade security system

Access revoked after logout (photos deleted)

10. Conclusion
The Neville Smart Car successfully integrates:

Biometric authentication

Wireless BLE control

Autonomous navigation

into a single, functional smart robotic system.
This project demonstrates practical engineering, system integration, and problem-solving skills in pervasive computing.

11. Acknowledgements
We thank the VU Amsterdam instructors, teaching assistants, MATLAB documentation teams, and Arduino online communities for their support, guidance, and valuable technical resources.
