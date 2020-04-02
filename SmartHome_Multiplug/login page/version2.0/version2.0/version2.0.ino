

#include <ESP8266WiFi.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>

// Replace with your network credentials
const char* ssid = "AUH 408";
const char* password = "0173134469789js";

//const int ESP_BUILTIN_LED = 2;
// Set web server port number to 80
WiFiServer server(80);

// Variable to store the HTTP request
String header;

// Auxiliar variables to store the current output state
String output5State = "DEACTIVE";
//String output4State = "off";

// Assign output variables to GPIO pins
const int output5 = 5;
//const int output4 = 4;

// Current time
unsigned long currentTime = millis();
// Previous time
unsigned long previousTime = 0; 
// Define timeout time in milliseconds (example: 2000ms = 2s)
const long timeoutTime = 2000;


void setup() {
  Serial.begin(115200);
   pinMode(output5, OUTPUT);
  //pinMode(output4, OUTPUT);
  // Set outputs to LOW
  digitalWrite(output5, LOW);
  //digitalWrite(output4, LOW);
  Serial.println("Booting");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }

  // Port defaults to 8266
  // ArduinoOTA.setPort(8266);

  // Hostname defaults to esp8266-[ChipID]
   ArduinoOTA.setHostname("AUH_409");

  // No authentication by default
   ArduinoOTA.setPassword((const char *)"alh84001");

  ArduinoOTA.onStart([]() {
    Serial.println("Start");
  });
  ArduinoOTA.onEnd([]() {
    Serial.println("\nEnd");
  });
  ArduinoOTA.onProgress([](unsigned int progress, unsigned int total) {
    Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
  });
  ArduinoOTA.onError([](ota_error_t error) {
    Serial.printf("Error[%u]: ", error);
    if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
    else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
    else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
    else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
    else if (error == OTA_END_ERROR) Serial.println("End Failed");
  });
  ArduinoOTA.begin();
  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  //pinMode(ESP_BUILTIN_LED, OUTPUT);
  server.begin();
}

void loop() {
  ArduinoOTA.handle();
  
  WiFiClient client = server.available();   // Listen for incoming clients

  if (client) {                             // If a new client connects,
    Serial.println("New Client.");          // print a message out in the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    currentTime = millis();
    previousTime = currentTime;
    while (client.connected() && currentTime - previousTime <= timeoutTime) { // loop while the client's connected
      currentTime = millis();         
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        Serial.write(c);                    // print it out the serial monitor
        header += c;
        if (c == '\n') {                    // if the byte is a newline character
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println("Connection: close");
            client.println();
            
            // turns the GPIOs on and off
            if (header.indexOf("GET /5/ACTIVE") >= 0) {
              Serial.println("GPIO 5 ACTIVE");
              output5State = "ACTIVE";
              digitalWrite(output5, HIGH);
            } else if (header.indexOf("GET /5/DEACTIVE") >= 0) {
              Serial.println("GPIO 5 DEACTIVE");
              output5State = "DEACTIVE";
              digitalWrite(output5, LOW);
            } 
            /*else if (header.indexOf("GET /4/ACTIVE") >= 0) {
              Serial.println("GPIO 4 ACTIVE");
              output4State = "ACTIVE";
              digitalWrite(output4, HIGH);
            } else if (header.indexOf("GET /4/DEACTIVE") >= 0) {
              Serial.println("GPIO 4 DEACTIVE");
              output4State = "DEACTIVE";
              digitalWrite(output4, LOW);
            }*/
            
            // Display the HTML web page
            client.println("<!DOCTYPE html><html>");
            client.println("<head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            client.println("<link rel=\"icon\" href=\"data:,\">");
            // CSS to style the on/off buttons 
            // Feel free to change the background-color and font-size attributes to fit your preferences
            client.println("<style>html { font-family: Helvetica; display: inline-block; margin: 0px auto; text-align: center;}");
            client.println(".button { background-color: #195B6A; border: none; color: white; padding: 16px 40px;");
            client.println("text-decoration: none; font-size: 30px; margin: 2px; cursor: pointer;}");
            client.println(".button2 {background-color: #77878A;}</style></head>");
            
            // Web Page Heading
            client.println("<body bgcolor='black'><font color='red'><h1>AULA 409 Control Room</h1>");
            
            // Display current state, and ON/OFF buttons for GPIO 5  
            client.println("<p>light1  " + output5State + "</p>");
            // If the output5State is off, it displays the ON button       
            if (output5State=="DEACTIVE") {
              client.println("<p><a href=\"/5/ACTIVE\"><button class=\"button\">ACTIVE</button></a></p>");
            } else {
              client.println("<p><a href=\"/5/DEACTIVE\"><button class=\"button button2\" >DEACTIVE</button></a></p>");
            } 
               
            // Display current state, and ON/OFF buttons for GPIO 4  
            //client.println("<p>GPIO 4 - State " + output4State + "</p>");
            // If the output4State is off, it displays the ON button       
           // if (output4State=="off") {
             // client.println("<p><a href=\"/4/on\"><button class=\"button\">ON</button></a></p>");
           // } else {
            //  client.println("<p><a href=\"/4/off\"><button class=\"button button2\">OFF</button></a></p>");
           // }
            client.println("</font)</body></html>");
            
            // The HTTP response ends with another blank line
            client.println();
            // Break out of the while loop
            break;
          } else { // if you got a newline, then clear currentLine
            currentLine = "";
          }
        } else if (c != '\r') {  // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
      }
    }
    // Clear the header variable
    header = "";
    // Close the connection
    client.stop();
    Serial.println("Client disconnected.");
    Serial.println("");
  }
  
}
