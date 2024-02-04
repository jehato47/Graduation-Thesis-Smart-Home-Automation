// #include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
// #include <Wire.h>
#include <ArduinoJson.h>            // https://github.com/bblanchon/ArduinoJson 

// #include <Adafruit_Sensor.h>
// #include <Adafruit_BME280.h>
#include "time.h"
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"
// #if defined(ESP32) || defined(PICO_RP2040)

#define FIREBASE_HOST "https://cu-smart-home-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "gnpqpD277MfiqVhfGgndfGagdcMwWORQTVmG3DKb"

#define _SSID "jehat12"          // Your WiFi SSID
#define _PASSWORD "12345678"      // Your WiFi Password


bool isAirConditionerOn = false;
bool isLivingRoomLightOn = false;

// Analog Input
const int lightSensor = 32; // Analog giriş için kullanılacak pin (GPIO32)
const int gasSensor = 35;
const int valve = 21;

// Outputs
const int air_conditioner = 5;
const int smartLight = 5;
const int tv = 2;
const int ldr_led = 4;


int lightValue = 0;
int gasValue = 0;


FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
const char* ntpServer = "pool.ntp.org";

// Variable to save USER UID
String uid;
unsigned long sendDataPrevMillis = 0;
unsigned long count = 0;

void setup() {
    Serial.begin(115200);

    WiFi.begin(_SSID, _PASSWORD);
    Serial.print("Connecting to Wi-Fi");
    while (WiFi.status() != WL_CONNECTED)
    {
        Serial.print(".");
        delay(300);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    configTime(0, 0, ntpServer);


    Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

    /* Assign the api key (required) */
    config.api_key = "AIzaSyDnDNmxd8N_U9h3xfHF_txB4nWo6apJ9es";

    /* Assign the user sign in credentials */
    auth.user.email = "jehato.47@hotmail.com";
    auth.user.password = "123465789Jad";

    /* Assign the RTDB URL (required) */
    config.database_url = "https://cu-smart-home-default-rtdb.firebaseio.com";

    /* Assign the callback function for the long running token generation task */
    config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

    // Or use legacy authenticate method
    // config.database_url = DATABASE_URL;
    // config.signer.tokens.legacy_token = "<database secret>";

    Firebase.begin(&config, &auth);

    // Comment or pass false value when WiFi reconnection will control by your code or third party library
    Firebase.reconnectWiFi(true);
}

void loop() {
    if (Firebase.ready() && (millis() - sendDataPrevMillis > 10000 || sendDataPrevMillis == 0))
    {
        sendDataPrevMillis = millis();

        // pushJsonWithId();


        checkVariables();
        // uploadSensorValues();

        count++;
    }
}


void pushJsonWithId(){
  FirebaseJson json;
  json.setDoubleDigits(3);
  json.add("title", "Arduinodan veri alındı");

  // Push the json data to a new child node under "/test/push"
  Serial.printf("Push json... %s\n", Firebase.RTDB.pushJSON(&fbdo, "/notifications", &json) ? "ok" : fbdo.errorReason().c_str());

  // Get the push ID using fbdo.pushName()
  String pushId = fbdo.pushName();

  // Print the push ID
  Serial.printf("Push ID: %s\n", pushId.c_str());
  
  

  json.add("time", getTime());

  // Update the pushed data by modifying the "value" field with a new value (count + 0.29745)
  // json.set("value", count + 0.29745);
  json.set("isRead", false);
  json.add("image", "image_path");
  json.add("type", "urgent");
  // json.add("title", "Arduino dan veri alındı");
  json.add("id", pushId);
  Serial.printf("Update json... %s\n\n", Firebase.RTDB.updateNode(&fbdo, "/notifications/" + pushId, &json) ? "ok" : fbdo.errorReason().c_str());
}

unsigned long getTime() {
  time_t now;
  struct tm timeinfo;
  
  if (!getLocalTime(&timeinfo)) {
    // Serial.println("Failed to obtain time");
    return 0;
  }
  
  // Convert struct tm to time_t
  now = mktime(&timeinfo);
  
  return now;
}

void checkVariables (){
  Serial.printf("Get json... %s\n", Firebase.RTDB.getJSON(&fbdo, "/interiorLighting") ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());

  FirebaseJson jVal;
  Serial.printf("Get json ref... %s\n", Firebase.RTDB.getJSON(&fbdo, "/interiorLighting", &jVal) ? jVal.raw() : fbdo.errorReason().c_str());

  String status;
  StaticJsonDocument<200> jsonDocument;
  DeserializationError error = deserializeJson(jsonDocument, jVal.raw());
  if (error) {
    Serial.print("Parsing failed: ");
    Serial.println(error.c_str());
    return;
  }

  String ac = jsonDocument["air_conditioner"];
  String living_room = jsonDocument["living_room"];


  isAirConditionerOn = ac == "open_state";
  isLivingRoomLightOn = living_room == "open_state";

  Serial.println(isAirConditionerOn);
  Serial.println(isLivingRoomLightOn);
  
}

// void setLedBrightness(int brightness) {
//   int data = firebase.getInt("interiorLighting/led_brightness");
//   Serial.println(data);
//   int br = 1024 / 100 * data;
//   ledcWrite(0, br);

// }


void uploadSensorValues(){
  readSensors();

  FirebaseJson json;
  json.setDoubleDigits(3);
  json.add("light", lightValue);

  // Push the json data to a new child node under "/test/push"
  Serial.printf("Push json... %s\n", Firebase.RTDB.pushJSON(&fbdo, "/sensorValues", &json) ? "ok" : fbdo.errorReason().c_str());

  String pushId = fbdo.pushName();

  Serial.printf("Push ID: %s\n", pushId.c_str());
  

  json.set("gas", gasValue);
  Serial.printf("Update json... %s\n\n", Firebase.RTDB.updateNode(&fbdo, "/sensorValues/" + pushId, &json) ? "ok" : fbdo.errorReason().c_str());
}

void readSensors(){
  lightValue = analogRead(lightSensor);
  gasValue = analogRead(gasSensor);

  // Senaryoya göre bildirim gidecek ve sürekli çekilen verilere göre gerekli yerler çalışacak

  // Serial.print("light value: ");
  // Serial.println(lightValue);

  // Serial.print("Gas value: ");
  // Serial.println(gasValue);
}
