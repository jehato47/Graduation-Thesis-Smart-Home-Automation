#include <ESP32Firebase.h>

#define _SSID "Vodafone"          // Your WiFi SSID
#define _PASSWORD "Jehat1212"      // Your WiFi Password
#define REFERENCE_URL "https://cu-smart-home-default-rtdb.firebaseio.com"  // Your Firebase project reference url
#define OUTPUT_PIN 5           // Define your output pin (example pin 13)

Firebase firebase(REFERENCE_URL);

const int fullBrightness = 1023; // Max brightness for 10-bit resolution
const int halfBrightness = 10; // 50% brightness for 10-bit resolution

void setup() {
  Serial.begin(115200);
  pinMode(OUTPUT_PIN, OUTPUT); // Set the pin as output

  ledcSetup(0, 5000, 10); // Channel 0, 5000 Hz frequency, 10-bit resolution
  ledcAttachPin(OUTPUT_PIN, 0); // Attach the output pin to Channel 0

  // Rest of your setup code...
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(1000);

  // Connect to WiFi
  Serial.println();
  Serial.println();
  Serial.print("Connecting to: ");
  Serial.println(_SSID);
  WiFi.begin(_SSID, _PASSWORD);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print("-");
  }

  Serial.println("");
  Serial.println("WiFi Connected");

  // Print the IP address
  Serial.print("IP Address: ");
  Serial.print("http://");
  Serial.print(WiFi.localIP());
  Serial.println("/");
}

void loop() {
  // Retrieve data from Firebase
  String data = firebase.getString("interiorLighting/living_room");

  // Check if data is valid before printing
  if (data.equals("open_state")) {
    // Open state: Set LED to 100% brightness
    ledcWrite(0, fullBrightness); // Set LED brightness to full
  } else {
    // Other state: Set LED to 50% brightness
    ledcWrite(0, halfBrightness); // Set LED brightness to 50%
  }

  // Rest of your loop code...
  delay(2500); // Example delay of 2.5 seconds between each Firebase data retrieval
}
