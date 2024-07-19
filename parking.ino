#include "WiFiEsp.h"
#include "SoftwareSerial.h"
#include <LiquidCrystal_I2C.h>
#include <Servo.h>
Servo myservo;
#define SERVO_PIN_IN 13
LiquidCrystal_I2C lcd(0x27,16,4);  // set the LCD address from 0x27 to 0x3f if i2c address is 0x3f
int row=0;
SoftwareSerial softserial(A9, A8); // A9 to ESP_TX, A8 to ESP_RX by default
boolean flag=false;

#define light_sensor_1 A1
#define redLED_1 36
#define greenLED_1 38

#define light_sensor_2 A2
#define redLED_2 32
#define greenLED_2 34

#define light_sensor_3 A3
#define redLED_3 30
#define greenLED_3 31

#define light_sensor_4 A4
#define redLED_4 28
#define greenLED_4 29

#define ir_sensor_1 10
#define ir_sensor_2 9

int lightStatus_1 = 0;
int lightStatus_2 = 0;
int lightStatus_3 = 0;
int lightStatus_4 = 0;
String lightStr;
boolean dispo = true;

char ssid[] = "Joe Joe"; // replace ****** with your network SSID (name)
char pass[] = "0#123Joe#"; // replace ****** with your network password
int status = WL_IDLE_STATUS;

int ledStatus = LOW;

WiFiEspServer server(80);
// use a ring buffer to increase speed and reduce memory allocation
RingBuffer buf(8);

void setup()
{ 
  lcd.init();
  lcd.backlight();
  //capteur photosentitive
  pinMode(light_sensor_1, INPUT);
  pinMode(light_sensor_2, INPUT);
  pinMode(light_sensor_3, INPUT);
  pinMode(light_sensor_4, INPUT);

  // capteur Infrarouge 
  pinMode(ir_sensor_1, INPUT);
  pinMode(ir_sensor_2, INPUT);

  // leds
  pinMode(greenLED_1, OUTPUT);
  pinMode(redLED_1, OUTPUT);
  pinMode(greenLED_2, OUTPUT);
  pinMode(redLED_2, OUTPUT);
  pinMode(greenLED_3, OUTPUT);
  pinMode(redLED_3, OUTPUT);
  pinMode(greenLED_4, OUTPUT);
  pinMode(redLED_4, OUTPUT);

  //servo moteur
  pinMode(SERVO_PIN_IN, OUTPUT);

  Serial.begin(9600);   // initialize serial for debugging
  softserial.begin(115200);
  softserial.write("AT+CIOBAUD=9600\r\n");
  softserial.write("AT+RST\r\n");
  softserial.begin(9600);    // initialize serial for ESP module
  WiFi.init(&softserial);    // initialize ESP module

  // check for the presence of the shield
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue
    while (true);
  }

  // attempt to connect to WiFi network
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network
    status = WiFi.begin(ssid, pass);
  }

  Serial.println("You're connected to the network");
  printWifiStatus();
  
  // start the web server on port 80
  server.begin();
  // Affiche la disponibilité par défaut
  for (int i = 0; i < 4; i++) {
    lcd.setCursor(0, i); // Positionne le curseur au début de la ligne i
    lcd.print("Place ");
    lcd.print(i+1);        // Imprime l'entier i
    lcd.print(" : disponible");
  }
}

void loop()
{
  int sensorStatus_1 = digitalRead(ir_sensor_1);
  int sensorStatus_2 = digitalRead(ir_sensor_2);
  //Serial.println(sensorStatus_1);
  if(sensorStatus_1 == 0){
    open_door();
  }
  if(sensorStatus_2 == 0){
    close_door();
  }

  // lecture du capteur
  lightStatus_1=analogRead(light_sensor_1);
  lightStatus_2=analogRead(light_sensor_2);
  lightStatus_3=analogRead(light_sensor_3);
  lightStatus_4=analogRead(light_sensor_4);
  //Serial.println(lightStatus_2);

  // changement de statut parking
  lightStatus(lightStatus_1, redLED_1, greenLED_1, 0);
  lightStatus(lightStatus_2, redLED_2, greenLED_2, 1);
  lightStatus(lightStatus_3, redLED_3, greenLED_3, 2);
  lightStatus(lightStatus_4, redLED_4, greenLED_4, 3);

  WiFiEspClient client = server.available();  // listen for incoming clients

  if (client) {                               // if you get a client,
    Serial.println("New client");             // print a message out the serial port
    buf.init();                               // initialize the circular buffer
    while (client.connected()) {              // loop while the client's connected
      if (client.available()) {               // if there's bytes to read from the client,
        char c = client.read();               // read a byte, then
        buf.push(c);                          // push it to the ring buffer

        if (buf.endsWith("\r\n\r\n")) {
          sendHttpResponse(client);
     
          break;
        }  
      }
    }
    // close the connection
    client.stop();
    Serial.println("Client disconnected");
  }
}

void lightStatus(int status, int red, int green, int i){
    if (status>900) {
    digitalWrite(red, HIGH);
    digitalWrite(green, LOW); 
    dispo = false;
  }else
  {
    digitalWrite(red, LOW);
    digitalWrite(green, HIGH);
  }
    if(dispo){
      placesDisponible(dispo, i);
      //open_door();
   }else{
      placesDisponible(dispo, i);
      dispo = true;
      //close_door();
   }

}

void placesDisponible(boolean dispo, int i){
  lcd.setCursor(0, i);  // Positionne de nouveau le curseur au début de la ligne i
  lcd.print("Place ");  // Affiche "Place "
  lcd.print(i+1);         // Affiche l'entier i
  if(dispo){
    lcd.print(" : Disponible");
  }else{
    lcd.print(" : Occupee   ");
  }
}

void open_door() {
    myservo.attach(SERVO_PIN_IN); 
    delay(300);
    myservo.write(180);//servo goes to 0 degrees 
     delay(400);
    myservo.detach(); // save current of servo
    digitalWrite(SERVO_PIN_IN,LOW);
}
void close_door() {
    myservo.attach(SERVO_PIN_IN); 
    delay(300);
    myservo.write(0);//servo goes to 0 degrees 
     delay(400);
    myservo.detach(); // save current of servo
    digitalWrite(SERVO_PIN_IN,LOW);
}

void sendHttpResponse(WiFiEspClient client)
{
  // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
  // and a content-type so the client knows what's coming, then a blank line:
  client.println("HTTP/1.1 200 OK");
  client.println("Content-type:text/html");
  client.println();
  
  // the content of the HTTP response follows the header:
  client.print("<meta http-equiv=\"refresh\" content=\"5\"/>Light Sensor Status: ");
    client.print(lightStr);

}

void printWifiStatus()
{
  // print the SSID of the network you're attached to
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print where to go in the browser
  Serial.println();
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
  Serial.println();
}
