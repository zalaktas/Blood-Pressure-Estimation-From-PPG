# Blood-Pressure-Estimation-From-PPG

# Cuffless Blood Pressure Monitoring System

This project introduces a **Cuffless Blood Pressure Monitoring System** designed to provide a non-invasive, continuous, and user-friendly method for measuring blood pressure. It combines advanced hardware design, biosensors, and machine learning algorithms to improve accessibility and accuracy in blood pressure monitoring.

## Features
- **Photoplethysmograph (PPG) Sensor**: Captures blood flow data using the MAX30102 sensor.
- **Machine Learning Models**: Predicts systolic and diastolic blood pressure using MATLAB-based regression models.
- **Custom PCB Design**: Developed using KiCAD, integrated with Arduino UNO as a shield for seamless operation.
- **Bluetooth Communication**: Enables data transfer between Arduino and MATLAB for real-time processing.
- **OLED Display**: Provides user-friendly feedback, showing live measurements and device status.

## System Components
1. **Hardware**:
   - Arduino UNO board
   - MAX30102 PPG sensor
   - HC-06 Bluetooth module
   - 128x64 I2C OLED screen
   - Custom PCB for integration
2. **Software**:
   - Arduino IDE for hardware control and data acquisition.
   - MATLAB for signal processing, feature extraction, and model training.

## Methodology
1. **Data Acquisition**: PPG signals are captured and preprocessed using filters (e.g., moving average and detrend filters).
2. **Feature Extraction**: Metrics like heart rate, systolic upstroke time, and pulse width percentages are computed.
3. **Machine Learning**: Trained models using public and custom datasets achieve prediction errors of ~10 mmHg.
4. **Real-Time Feedback**: Processed data and predictions are displayed on the OLED screen and transmitted via Bluetooth.

## Key Results
- Successfully integrated hardware and software for continuous blood pressure monitoring.
- Achieved low prediction errors with machine learning models (RMSE: 10.4 mmHg for systolic, 10.2 mmHg for diastolic).

## Repository
Access the project [here](https://github.com/zalaktas/Blood-Pressure-Estimation-From-PPG).

---

Let me know if you'd like to add or modify any section!
