#define RXp2 16
#define TXp2 17

void setup() {
  Serial.begin(115200);
  Serial2.begin(9600, SERIAL_8N1, RXp2, TXp2);
}

void loop() {
  if (Serial2.available()) {
    String message = Serial2.readString();
    char messageArray[message.length() + 1];
    message.toCharArray(messageArray, message.length() + 1);

    // Strip unwanted characters
    strip(messageArray);

    // Convert back to String if needed
    String strippedMessage = String(messageArray);

    Serial.print("Message Received: ");
    Serial.println(strippedMessage);

    if (strippedMessage == "Hello Boss") {
      Serial.println("True");
    } else {
      Serial.println("False");
    }
  }
}

// Function to strip whitespace characters from both ends of a string
void strip(char* str) {
  // Remove leading spaces
  int start = 0;
  while (isspace(str[start])) {
    start++;
  }

  // Remove trailing spaces
  int end = strlen(str) - 1;
  while (end > start && isspace(str[end])) {
    end--;
  }

  // Shift the string to the beginning
  for (int i = start; i <= end; i++) {
    str[i - start] = str[i];
  }
  
  // Null-terminate the stripped string
  str[end - start + 1] = '\0';
}
