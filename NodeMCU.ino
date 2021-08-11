#include <DHT.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>

#define FIREBASE_HOST "automaticirrigationsyste-beeb7-default-rtdb.firebaseio.com" //remove http and / from firebase url
#define FIREBASE_AUTH "rt4zDtAlY1WvcX4L67NTsHCKlbNyXQxn86eGw2t6" //secret key of database here
#define WIFI_SSID "HUAWEI-Mji6"
#define WIFI_PASSWORD "GDQB3kGH"

DHT dht;
int echoPin = 16; //(D0)
int trigPin = 5; //(D1)
int relayOne = 4; //(D2)
int relayTwo = 0; //(D3)
int humidityTemperatureSensor = 2; //(D4)
int soilMoistureThreshold = 50; //Soil Moisture Threshold (in %)
int checkDelayTimes = 4; //Delay to Check conditions of soil (10 * 500ms)
int waterForTimes = 3; //Duration to water plants (70 * 500ms)
int tankHeight = 20; //Height of water tank in cmconst
const int AirValue = 755;   //you need to replace this value with Value_1
const int WaterValue = 365;  //you need to replace this value with Value_2
int soilMoistureValue = 0;
int soilmoisturepercent = 0;

//declaring pin 14 (D5) and pin 12 (D6) as for serial communication
SoftwareSerial gsmSerial(14, 12);

long duration;

void setup() {
  Serial.begin(9600);
  gsmSerial.begin(9600);
  pinMode(echoPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(relayOne, OUTPUT);
  pinMode(relayTwo, OUTPUT);
  dht.setup(humidityTemperatureSensor);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  if (getMotorStatus()) {
    turnOnMotor();
    
  } else {
    turnOffMotor();
    if (getSoilMoisture() < soilMoistureThreshold) {
      digitalWrite(relayOne, HIGH);
      digitalWrite(relayTwo, HIGH);
      for (int i = 0; i < waterForTimes; i++) {
        delay(500);
        sendToFirebase();
      }
      digitalWrite(relayOne, LOW);
      digitalWrite(relayTwo, LOW);
    }
    if (getWaterLevel() <= (0.25 * tankHeight)) {
      //sendMessage("Water level is below 25%. Please refill water tank!");
    }
  }
}

double getWaterLevel() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  float distance = 20 - (0.034 / 2 * duration);
  return distance;
}

int getSoilMoisture() {
  soilMoistureValue = analogRead(A0);  //put Sensor insert into soil
  soilmoisturepercent = map(soilMoistureValue, AirValue, WaterValue, 0, 100);
  return soilmoisturepercent;
}

float getTemperature() {
  delay(dht.getMinimumSamplingPeriod()); /* Delay of amount equal to sampling period */
  float temperature = dht.getTemperature();
  return temperature;
}

float getHumidity() {
  delay(dht.getMinimumSamplingPeriod()); /* Delay of amount equal to sampling period */
  float humidity = dht.getHumidity();
  return humidity;
}

void sendMessage(String message) {
  gsmSerial.println("AT+CMGF=1");    //Sets the GSM Module in Text Mode
  delay(1000);  // Delay of 1000 milliseconds
  gsmSerial.println("AT+CMGS=\"+23059208390\"\r"); // Replace with any mobile number
  delay(1000); // Delay of 1000 milliseconds
  gsmSerial.println(message);// The SMS text you want to send
  delay(100); // Delay of 1000 milliseconds
  gsmSerial.println((char)26);// ASCII code of CTRL+Z
  delay(1000); // Delay of 1000 milliseconds
}

void sendToFirebase() {
  int humidity = getHumidity();
  Firebase.setInt("Humidity", humidity);

  int soilmoisturepercent = getSoilMoisture();
  Firebase.setInt("SoilMoisture", soilmoisturepercent);

  int temperature = getTemperature();
  Firebase.setInt("Temperature", temperature);

  float waterLevel = getWaterLevel();
  Firebase.setFloat("WaterLevel", waterLevel);
}

void turnOnMotor() {
    digitalWrite(relayOne, HIGH);
    digitalWrite(relayTwo, HIGH);
    sendToFirebase();
}

void turnOffMotor() {
    digitalWrite(relayOne, LOW);
    digitalWrite(relayTwo, LOW);
    sendToFirebase();
}

bool getMotorStatus() {
  String motorStatus = Firebase.getString("MotorStatus");
  if (motorStatus == "active") return true;
  else return false;
}
