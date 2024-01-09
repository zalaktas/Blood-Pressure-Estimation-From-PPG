#include <Wire.h>
#include "MAX30105.h"
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_Sensor.h>

MAX30105 particleSensor;

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels

#define POTENTIOMETER_PIN A0
#define BUTTON_PIN 13

int age = 20;  // Default age
int weight = 70;  // Default weight
int height = 170;  // Default height
int genderVal = 0;  // 0 for Male, 1 for Female
int potValue = 50;

int selectedParameter = 0; // 0: Age, 1: Weight, 2: Height, 3: Gender, 4:Calculations

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

String BPM_data = "...";
String Sys_data = "...";
String Dia_data = "...";

void setup()
{
  Serial.begin(115200);
  //Serial.println(F("Initializing..."));

  // Initialize sensor
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) // Use default I2C port, 400kHz speed
  {
    Serial.println(F("MAX30105 was not found. Please check wiring/power.)"));
    //while (1);
  }

  // Setup to sense a nice-looking sawtooth on the plotter
  byte ledBrightness = 0x10; // Options: 0=Off to 255=50mA
  byte sampleAverage = 8;    // Options: 1, 2, 4, 8, 16, 32
  byte ledMode = 2;          // Options: 1 = Red only, 2 = Red + IR, 3 = Red + IR + Green
  int sampleRate = 1000;     // Options: 50, 100, 200, 400, 800, 1000, 1600, 3200
  int pulseWidth = 411;      // Options: 69, 118, 215, 411
  int adcRange = 4096;       // Options: 2048, 4096, 8192, 16384

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange); // Configure sensor with these settings

  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C))
  {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;
  }
  delay(2000);
  display.clearDisplay();
  display.setTextColor(WHITE);
}

void loop()
{
  // Check if the button is pressed
  if (digitalRead(BUTTON_PIN) == HIGH)
  {
    // Button is pressed, move to the next parameter 
    selectedParameter = (selectedParameter + 1) % 5;
    delay(500); // Debounce delay
  }
  
  switch (selectedParameter)
    {
    case 0:
      // Read potentiometer values
      potValue = analogRead(POTENTIOMETER_PIN);
      age = map(potValue, 0, 1023, 18, 99); // Map potentiometer range to age range (18 to 99 years)
      display.clearDisplay();
      display.setTextSize(1);
      display.setCursor(0, 0);
      display.print(F("Age: "));
      display.print(age);
      display.display();
      Serial.print(F("A"));
      Serial.println(age);
      break;
    case 1:
      potValue = analogRead(POTENTIOMETER_PIN);
      weight = map(potValue, 0, 1023, 40, 150); // Map potentiometer range to weight range (40 to 150 kg)
      display.clearDisplay();
      display.setTextSize(1);
      display.setCursor(0, 0);
      display.print(F("Age: "));
      display.print(age);

      display.setCursor(0, 15);
      display.print(F("Weight: "));
      display.print(weight);
      display.print(F(" kg"));
      display.display();
      Serial.print(F("W"));
      Serial.println(weight);
      break;
    case 2:
      potValue = analogRead(POTENTIOMETER_PIN);
      height = map(potValue, 0, 1023, 100, 220); // Map potentiometer range to height range (100 to 220 cm)
      display.clearDisplay();
      display.setTextSize(1);
      display.setCursor(0, 0);
      display.print(F("Age: "));
      display.print(age);

      display.setCursor(0, 15);
      display.print(F("Weight: "));
      display.print(weight);
      display.print(F(" kg"));

      display.setCursor(0, 30);
      display.print(F("Height: "));
      display.print(height);
      display.print(F(" cm"));
      display.display();
      Serial.print(F("H"));
      Serial.println(height);
      break;
    case 3:
      potValue = analogRead(POTENTIOMETER_PIN);
      genderVal = map(potValue, 0, 1023, 0, 100);
      display.clearDisplay();
      display.setTextSize(1);
      display.setCursor(0, 0);
      display.print(F("Age: "));
      display.print(age);

      display.setCursor(0, 15);
      display.print(F("Weight: "));
      display.print(weight);
      display.print(F(" kg"));

      display.setCursor(0, 30);
      display.print(F("Height: "));
      display.print(height);
      display.print(F(" cm"));

      display.setCursor(0, 45);
      display.print(F("Gender: "));
      display.print(genderVal > 50 ? F("Male") : F("Female"));
      display.display();
      break;
    case 4:
    for (int  i =5; i>0; i--){
     display.clearDisplay();
     display.setTextSize(1);
     display.setCursor(0, 0);
     display.print(F("Place your finger to the sensor."));
     display.setCursor(0, 20);
     display.print(F("Mesurement starts in:")); 
     display.setTextSize(2);
     display.setCursor(0, 30);
     display.print(i);
     display.print(F(" seconds."));
     display.display();
     delay(1000);
    }     
    Serial.print(F("G"));
    Serial.println(genderVal > 50 ? 1 : 0);
    selectedParameter ++;
    break;
    case 5:
      // Read and print the IR sensor data
      uint32_t IR_data = particleSensor.getIR();
      Serial.println(IR_data); 
      if (Serial.available() > 0)
      {
        String receivedData = Serial.readStringUntil('\n');
        Serial.print(F("Received data: "));
        Serial.println(receivedData);
        if (receivedData.startsWith("BP:"))
        {
          BPM_data = receivedData.substring(3);
          Serial.print(F("Received BP data: "));
          Serial.println(BPM_data);
        }
        else if (receivedData.startsWith("SY:"))
        {
          Sys_data = receivedData.substring(3);
          Serial.print(F("Received Sys data: "));
          Serial.println(Sys_data);
        }
        else if (receivedData.startsWith("DI:"))
        {
          Dia_data = receivedData.substring(3);
          Serial.print(F("Received Dia data: "));
          Serial.println(Dia_data);
        }
      }

      // Clear display
      display.clearDisplay();

      display.setTextSize(1);
      display.setCursor(0, 0);
      display.print(F("BPM: "));
      display.setTextSize(2);
      display.setCursor(0, 10);
      display.print(BPM_data);

      display.setTextSize(1);
      display.setCursor(64, 0);
      display.print(F("IR value: "));
      display.setTextSize(2);
      display.setCursor(64, 10);
      display.print(IR_data);

      display.setTextSize(1);
      display.setCursor(0, 35);
      display.print(F("Sys BP: "));
      display.setTextSize(2);
      display.setCursor(0, 45);
      display.print(Sys_data);

      display.setTextSize(1);
      display.setCursor(64, 35);
      display.print(F("Dia BP: "));
      display.setTextSize(2);
      display.setCursor(64, 45);
      display.print(Dia_data);

      display.display();
      break;
  }

}  