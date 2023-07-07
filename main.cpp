#include <Arduino.h>
#include <DHTesp.h>
#include <WiFi.h>
#include <Ticker.h>
#include <Wire.h>
#include "DHTesp.h"
#include "firebase.h"

#define PIN_DHT 5

const char* ssid = "Kokoro";
const char* password = "oranggila1220";
DHTesp dht;

void WifiConnect();
void onSendSensor();


void setup() {
  Serial.begin(115200);
  dht.setup(PIN_DHT, DHTesp::DHT11);

  WifiConnect();
  Firebase_Init("cmd");

  // Initialize door lock state
  Firebase.RTDB.setInt(&fbdo, "/data/door_lock", 0); // 0 = unlocked, 1 = locked

  Serial.println("System ready.");
}

void lockUnlocked(int value)
{
  if (value == 1) {
    // Update the Firebase value
    Firebase.RTDB.setInt(&fbdo, "/data/door_lock", value);
  } if (value == 0) {
    // Update the Firebase value
    Firebase.RTDB.setInt(&fbdo, "/data/door_lock", value);

    Serial.println("sending on off values to firebase...");
  }
}

void loop() {
  onSendSensor();
  delay(5000);
}

void onFirebaseStream(FirebaseStream data)
{
  if (data.dataType() == "int") {
    int value = data.intData();
    // Process the received value from Firebase
    // For example, you can call functions to control the LED strip based on the received value
    if (data.streamPath() == "/data/door_lock") {
      lockUnlocked(value);
    }
  }
}

void onSendSensor()
{
  float humidity = dht.getHumidity();
  float temperature = dht.getTemperature();
  if (dht.getStatus()==DHTesp::ERROR_NONE)
  {
    Serial.printf("Temperature: %.2f C, Humidity: %.2f %%\n",
      temperature, humidity);
    Firebase.RTDB.setFloat(&fbdo, "/data/temperature", temperature);
    Firebase.RTDB.setFloat(&fbdo, "/data/humidity", humidity);
  }
  else
  {
    Serial.printf("DHT11 error: %d\n", dht.getStatus());
  }
}

void WifiConnect()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }
  Serial.print("System connected with IP address: ");
  Serial.println(WiFi.localIP());
  Serial.printf("RSSI: %d\n", WiFi.RSSI());
}
