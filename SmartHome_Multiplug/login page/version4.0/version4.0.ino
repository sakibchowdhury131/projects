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
#include <ESP8266WiFi.h>
#include "Adafruit_MQTT.h"
#include "Adafruit_MQTT_Client.h"


#define AIO_SERVER      "io.adafruit.com"
#define AIO_SERVERPORT  1883                   // use 8883 for SSL
#define AIO_USERNAME    "sakib_chowdhury"
#define AIO_KEY         "aio_QihB28dJAWuA5A3hWeGQLyE8DfYH"

const int socket1 = 5;
const int socket2 = 0;
const int socket3 = 14;
const int socket4 = 12;

    
Ticker ticker;



AsyncWebServer server(80);
DNSServer dns;



/************ Global State (you don't need to change this!) ******************/

// Create an ESP8266 WiFiClient class to connect to the MQTT server.
WiFiClient client;
// or... use WiFiFlientSecure for SSL
//WiFiClientSecure client;

// Setup the MQTT client class by passing in the WiFi client and MQTT server and login details.
Adafruit_MQTT_Client mqtt(&client, AIO_SERVER, AIO_SERVERPORT, AIO_USERNAME, AIO_KEY);


/****************************** Feeds ***************************************/


// Notice MQTT paths for AIO follow the form: <username>/feeds/<feedname>
Adafruit_MQTT_Publish port1_status = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/port1_status");
Adafruit_MQTT_Publish port2_status = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/port2_status");
Adafruit_MQTT_Publish port3_status = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/port3_status");
Adafruit_MQTT_Publish port4_status = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/port4_status");
Adafruit_MQTT_Publish _status = Adafruit_MQTT_Publish(&mqtt, AIO_USERNAME "/feeds/_status");


// Setup a feed called 'onoff' for subscribing to changes.
Adafruit_MQTT_Subscribe port1_control = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/port1_control");
Adafruit_MQTT_Subscribe port2_control = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/port2_control");
Adafruit_MQTT_Subscribe port3_control = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/port3_control");
Adafruit_MQTT_Subscribe port4_control = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/port4_control");
Adafruit_MQTT_Subscribe _reset = Adafruit_MQTT_Subscribe(&mqtt, AIO_USERNAME "/feeds/reset");


void tick();
void configModeCallback (AsyncWiFiManager *myWiFiManager);
void wifi_connect();
void MQTT_connect();


AsyncWiFiManager wifiManager(&server,&dns);



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
  pinMode(BUILTIN_LED, OUTPUT);

  Serial.println("Booting");
  
  wifi_connect();
  ArduinoOTA.setHostname("multiplug_root");
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
  // Setup MQTT subscription for onoff feed.
  mqtt.subscribe(&port1_control);
  mqtt.subscribe(&port2_control);
  mqtt.subscribe(&port3_control);
  mqtt.subscribe(&port4_control);
  mqtt.subscribe(&_reset);

}

void loop() {
  // put your main code here, to run repeatedly:
  wifi_connect();
  MQTT_connect();
  Adafruit_MQTT_Subscribe *subscription;

  while ((subscription = mqtt.readSubscription(5000))) {
    
    if (subscription == &port1_control) {
      if (strcmp((char *)port1_control.lastread , "ON") ==0)
      {
        digitalWrite(socket1, LOW);
      }

      else
      {
        digitalWrite(socket1, HIGH);
      }
    }

    
    if (subscription == &port2_control) {
      if (strcmp((char *)port2_control.lastread , "ON") ==0)
      {
        digitalWrite(socket2, LOW);
      }

      else
      {
        digitalWrite(socket2, HIGH);
      }
    }

    if (subscription == &port3_control) {
      if (strcmp((char *)port3_control.lastread , "ON") ==0)
      {
        digitalWrite(socket3, LOW);
        Serial.println('got');
      }

      else
      {
        digitalWrite(socket3, HIGH);
      }
    }

    if (subscription == &port4_control) {
      if (strcmp((char *)port4_control.lastread , "ON") ==0)
      {
        digitalWrite(socket4, LOW);
      }

      else
      {
        digitalWrite(socket4, HIGH);
      }
    }

    if (subscription == &_reset) {
      if (strcmp((char *)_reset.lastread , "reset") ==0)
      {
        wifiManager.resetSettings();
        while(1);
      }
    }
    ArduinoOTA.handle();
  }





  Serial.print(F("\nSending port1 val "));
  if (! port1_status.publish(!digitalRead(socket1))) {
    Serial.println(F("Failed"));
  } else {
    Serial.println(F("OK!"));
  }
  ArduinoOTA.handle();
  delay(1200);


  Serial.print(F("\nSending port2 val "));
  if (! port2_status.publish(!digitalRead(socket2))) {
    Serial.println(F("Failed"));
  } else {
    Serial.println(F("OK!"));
  }
  ArduinoOTA.handle();
  delay(1200);


  Serial.print(F("\nSending port3 val "));
  if (! port3_status.publish(!digitalRead(socket3))) {
    Serial.println(F("Failed"));
  } else {
    Serial.println(F("OK!"));
  }
  ArduinoOTA.handle();
  delay(1200);


  Serial.print(F("\nSending port4 val "));
  if (! port4_status.publish(!digitalRead(socket4))) {
    Serial.println(F("Failed"));
  } else {
    Serial.println(F("OK!"));
  }
  ArduinoOTA.handle();
  delay(1200);

  
  

}

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


void wifi_connect()
{
  if (WiFi.status() == WL_DISCONNECTED)
  {
    
    ticker.attach(0.6, tick);
  
    wifiManager.autoConnect("Multiplug Access Point");
    ArduinoOTA.handle();
    Serial.println("connected...yeey :)");
    
  
    ticker.detach();
    digitalWrite(BUILTIN_LED, LOW);
  }
  else 
  {
  return; 
  }
}



void MQTT_connect() {
  int8_t ret;

  // Stop if already connected.
  if (mqtt.connected()) {
    return;
  }
  ticker.attach(0.2, tick);
  Serial.print("Connecting to MQTT... ");


  while ((ret = mqtt.connect()) != 0) { // connect will return 0 for connected
       wifi_connect();
       Serial.println(mqtt.connectErrorString(ret));
       Serial.println("Retrying MQTT connection in 5 seconds...");
       mqtt.disconnect();
       delay(5000);  // wait 5 seconds
       ArduinoOTA.handle();
       

  }

  ticker.detach();
  digitalWrite(BUILTIN_LED, LOW);

  
  Serial.println("MQTT Connected!");
  if (! _status.publish("connected to server!!!")) {
    Serial.println(F("Failed"));
    } else {
    Serial.println(F("OK!"));
    }
   delay(1200);
}
