#if defined(ESP8266)
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
#else
#include <WiFi.h>
#endif

//needed for library
#include <ESPAsyncWebServer.h>
#include <ESPAsyncWiFiManager.h>         //https://github.com/tzapu/WiFiManager
#include <FS.h>
#include <Wire.h>
#include <ESP8266mDNS.h>
#include <WiFiUdp.h>
#include <ArduinoOTA.h>
#include <Ticker.h>




    
Ticker ticker;



void tick() // for ticking the led indicator during boot
{
  //toggle state
  int state = digitalRead(BUILTIN_LED);  // get the current state of GPIO1 pin
  digitalWrite(BUILTIN_LED, !state);     // set pin to the opposite state
}


void configModeCallback (AsyncWiFiManager *myWiFiManager) { //unnecessary
  Serial.println("Entered config mode");
  Serial.println(WiFi.softAPIP());
  //if you used auto generated SSID, print it
  Serial.println(myWiFiManager->getConfigPortalSSID());
  //entered config mode, make led toggle faster
  ticker.attach(0.2, tick);
}




AsyncWebServer server(80);
DNSServer dns;



// Set LED GPIO
const int socket1 = 5;
const int socket2 = 0;
const int socket3 = 14;
const int socket4 = 12;


// Stores LED state
String ledState; 



String processor(const String& var){
  Serial.println(var);
  if(var == "STATE"){
    if(digitalRead(socket1)){
      ledState = "ON";
    }
    else{
      ledState = "OFF";
    }
    Serial.print(socket1);
    return ledState;
  }
  
}


void setup() {
    // put your setup code here, to run once:
    Serial.begin(115200);

    digitalWrite(socket1,1);
    digitalWrite(socket2,1); 
    digitalWrite(socket3,1);   
    digitalWrite(socket4,1);

    
    pinMode(socket1, OUTPUT);
    pinMode(socket2, OUTPUT);
    pinMode(socket3, OUTPUT);
    pinMode(socket4, OUTPUT);


    
    Serial.println("Booting");

      //set led pin as output
  pinMode(BUILTIN_LED, OUTPUT);
  // start ticker with 0.5 because we start in AP mode and try to connect
  ticker.attach(0.6, tick);

  // Initialize the sensor
  // Initialize SPIFFS
  if(!SPIFFS.begin()){
    Serial.println("An Error has occurred while mounting SPIFFS");
    return;
  }


    //WiFiManager
    //Local intialization. Once its business is done, there is no need to keep it around
    AsyncWiFiManager wifiManager(&server,&dns);
    //reset saved settings
    //wifiManager.resetSettings();
    //set custom ip for portal
    //wifiManager.setAPConfig(IPAddress(10,0,1,1), IPAddress(10,0,1,1), IPAddress(255,255,255,0));
    //fetches ssid and pass from eeprom and tries to connect
    //if it does not connect it starts an access point with the specified name
    //here  "AutoConnectAP"
    //and goes into a blocking loop awaiting configuration4
    wifiManager.setSTAStaticIPConfig(IPAddress(192,168,0,122), IPAddress(192,168,0,1), IPAddress(255,255,255,0));
    wifiManager.autoConnect("AULA 409");
    //or use this for auto generated name ESP + ChipID
    //wifiManager.autoConnect();
    //if you get here you have connected to the WiFi
    Serial.println("connected...yeey :)");

    ticker.detach();
  //keep LED on
    digitalWrite(BUILTIN_LED, LOW);


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

  // Route for root / web page
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/index.html", String());
  });
  
  // Route to load style.css file
  server.on("/style.css", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/style.css", "text/css");
  });

  server.on("/success.html", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/success.html", String());
  });

  server.on("/login.css", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/login.css", "text/js");
  });

  server.on("/login.js", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send(SPIFFS, "/login.js", "text/js");
  });

  // Route to set socket1 to HIGH
  server.on("/onsocket1", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket1, LOW);    
    request->send(SPIFFS, "/success.html", String());
  });
  
  // Route to set socket1 to LOW
  server.on("/offsocket1", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket1, HIGH);    
    request->send(SPIFFS, "/success.html", String());
  });






      // Route to set socket2 to HIGH
  server.on("/onsocket2", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket2, LOW);    
    request->send(SPIFFS, "/success.html", String());
  });
  
  // Route to set socket2 to LOW
  server.on("/offsocket2", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket2, HIGH);    
    request->send(SPIFFS, "/success.html", String());
  });



    
      // Route to set socket3 to HIGH
  server.on("/onsocket3", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket3, LOW);    
    request->send(SPIFFS, "/success.html", String());
  });
  
  // Route to set socket3 to LOW
  server.on("/offsocket3", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket3, HIGH);    
    request->send(SPIFFS, "/success.html", String());
  });



    
      // Route to set socket4 to HIGH
  server.on("/onsocket4", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket4, LOW);    
    request->send(SPIFFS, "/success.html", String());
  });
  
  // Route to set socket4 to LOW
  server.on("/offsocket4", HTTP_GET, [](AsyncWebServerRequest *request){
    digitalWrite(socket4, HIGH);    
    request->send(SPIFFS, "/success.html", String());
  });





  
  // Start server
  server.begin();
}

void loop() {
    // put your main code here, to run repeatedly:
    ArduinoOTA.handle();


}
