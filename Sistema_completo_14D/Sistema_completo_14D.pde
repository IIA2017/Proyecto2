/*  
 *  --[] -  
 *  
 *   
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or 
 *  (at your option) any later version. 
 *  
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details. 
 *  
 *  You should have received a copy of the GNU General Public License 
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *  
 *  Version:           
 *  Design:            David Gascón 
 *  Implementation:    Carlos Bello
 *  
 *  Modification:      Pedro Fenoy Illacer
 *                     Carlos Nache Romo
 *                     Ángel Oller Oller
 *                     Javier López Milán
 *                     Gustavo Martín de Dios
 *                     Néstor Pastor Gutiérrez
 *                     
 */

#include <WaspSensorEvent_v30.h>
#include <WaspWIFI_PRO.h>


////////////////////////////
// TIME
///////////////////////////

int year;
int month;
int day;
int hour;
int minute;
int second;

// buffer to set the date and time
char buffer[100];
char input[100];


///////////////////////////////////
// PIR and LUMINOSITY SENSORS:
///////////////////////////////////

pirSensorClass pir(SOCKET_1);
uint8_t value = 0;
uint32_t luxes = 0;

///////////////////////////////////
// COMMUNICATION
///////////////////////////////////


// choose socket (SELECT USER'S SOCKET)
uint8_t socket = SOCKET0;

// WiFi AP settings (CHANGE TO USER'S AP)
///////////////////////////////////////
char ESSID[] = "ONO4562";
char PASSW[] = "4vKvRS1MtQ3d";

// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "192.168.1.217";
char REMOTE_PORT[] = "12345";
char LOCAL_PORT[]  = "3000";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;
uint16_t socket_handle = 0;


char mensaje[60]="";




void setup() 
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));

  //Set Time

  decideTime();



  // initialize digital pin LED_BUILTIN as an output.
  pinMode(19, OUTPUT);
  pinMode(20, OUTPUT);
  
  // Turn on the sensor board
  Events.ON();

  // Firstly, wait for PIR signal stabilization
  value = pir.readPirSensor();
  while (value == 1)
  {
    USB.println(F("...wait for PIR stabilization"));
    delay(1000);
    value = pir.readPirSensor();    
  }
  
  // Enable interruptions from the board
  Events.attachInt();

  
  
}



void loop() 
{
  ///////////////////////////////////////
  // 1. Read the sensor level
  ///////////////////////////////////////
  // Read the PIR Sensor
  value = pir.readPirSensor();
  luxes = Events.getLuxes(INDOOR); 

  if (luxes >= 10)
  {
    digitalWrite(19, LOW);    // turn the GREEN LED off by making the voltage LOW 
    digitalWrite(20, LOW);    // turn the RED LED off          
  
  // Print the info
  if (value == 1) 
  {
    USB.println(F("Sensor output: Presence detected"));
    digitalWrite(20, LOW);    // turn the RED LED off 
    digitalWrite(19, HIGH);   // turn the GREEN LED on

    sendWarning();
  } 
  else 
  {
    USB.println(F("Sensor output: Presence not detected")); 
    digitalWrite(19, LOW);    // turn the GREEN LED off by making the voltage LOW
    digitalWrite(20, HIGH);   // turn the RED LED on
  }
  
  
  ///////////////////////////////////////
  // 2. Go to deep sleep mode
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);
  USB.ON();
  USB.println(F("wake up\n"));
  
  
  ///////////////////////////////////////
  // 3. Check Interruption Flags
  ///////////////////////////////////////
    
  // 3.1. Check interruption from RTC alarm
  if (intFlag & RTC_INT)
  {
    USB.println(F("-----------------------------"));
    USB.println(F("RTC INT captured"));
    USB.println(F("-----------------------------"));

    // clear flag
    intFlag &= ~(RTC_INT);
  }
  
  // 3.2. Check interruption from Sensor Board
  if (intFlag & SENS_INT)
  {
    // Disable interruptions from the board
    Events.detachInt();
    
    // Load the interruption flag
    Events.loadInt();
    
    // In case the interruption came from PIR
    if (pir.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from PIR"));
      USB.println(F("-----------------------------"));
    }    
    
    // User should implement some warning
    // In this example, now wait for signal
    // stabilization to generate a new interruption
    // Read the sensor level
    value = pir.readPirSensor();


  if (value == 1) 
  {
          USB.println(F("Sensor output: Presence detected"));
          digitalWrite(20, LOW);    // turn the LED off by making the voltage LOW
          digitalWrite(19, HIGH);   // turn the GREEN LED on

          sendWarning();

  } 
  else 
    {

          USB.println(F("Sensor output: Presence not detected"));
          digitalWrite(19, LOW);    // turn the LED off by making the voltage LOW
          digitalWrite(20, HIGH);   // turn the RED LED
    }
     
 

    while (value == 1)
    {
      USB.println(F("...wait for PIR stabilization"));
      delay(1000);
      value = pir.readPirSensor();
      luxes = Events.getLuxes(INDOOR);
    }
    
    // Clean the interruption flag
    intFlag &= ~(SENS_INT);
    
    // Enable interruptions from the board
    Events.attachInt();
  }
  }

    // Part 1: Read Values
  // Read the luxes sensor 
  // Options:
  //    - OUTDOOR
  //    - INDOOR
 else 
 {
          digitalWrite(20, LOW);    // turn the LED off by making the voltage LOW
          digitalWrite(19, HIGH);   // turn the GREEN LED
 }
   
  // Part 2: USB printing
  // Print values through the USB
  USB.print(F("Luxes: "));
  USB.print(luxes);
  USB.println(F(" lux"));
  delay(1000);
  
}



/*************************************
*
*  Set time
*
***************************************/

void decideTime()
{

  // Powers RTC up, init I2C bus and read initial values
  RTC.ON();


  USB.println(F("-------------------------------------"));
  USB.println(F("Set RTC Date and Time via USB port"));
  USB.println(F("-------------------------------------"));

  /////////////////////////////////
  //  YEAR
  /////////////////////////////////
  do
  {
    USB.print("Insert year [yy]:");    
  }
  while( getData(2) != true );
  
  year=atoi(input);
  USB.println(year);
  

  /////////////////////////////////
  //  MONTH
  /////////////////////////////////
  do
  {
    USB.print("Insert month [mm]:");    
  }
  while( getData(2) != true );
  
  month=atoi(input);
  USB.println(month);
  

  /////////////////////////////////
  //  DAY
  /////////////////////////////////
  do
  {
    USB.print("Insert day [dd]:");    
  }
  while( getData(2) != true );
  
  day=atoi(input);
  USB.println(day);
  

  /////////////////////////////////
  //  HOUR
  /////////////////////////////////
  do
  {
    USB.print("Insert Hour [HH]:");    
  }
  while( getData(2) != true );
  
  hour=atoi(input);
  USB.println(hour);

  /////////////////////////////////
  //  MINUTE
  /////////////////////////////////
  do
  {
    USB.print("Insert minute [MM]:");    
  }
  while( getData(2) != true );
  
  minute=atoi(input);
  USB.println(minute);

  /////////////////////////////////
  //  SECOND
  /////////////////////////////////
  do
  {
    USB.print("Insert second [SS]:");    
  }
  while( getData(2) != true );
  
  second=atoi(input);
  USB.println(second);
  
  
  /////////////////////////////////
  //  create buffer
  /////////////////////////////////
  sprintf(buffer, "%02u:%02u:%02u:%02u:%02u:%02u:%02u",
                                                        year, 
                                                        month, 
                                                        day, 
                                                        RTC.dow(year, month,day), 
                                                        hour, 
                                                        minute, 
                                                        second );
  USB.println(buffer);

  // Setting time [yy:mm:dd:dow:hh:mm:ss]
  RTC.setTime(buffer);
}




/*********************************
*
* get numBytes from USB port 
*
**********************************/
boolean getData(int numBytes)
{ 
  memset(input, 0x00, sizeof(input) );
  int i=0;
  USB.flush();
  int nRead=0;
  
  while(!USB.available());
  
  while(USB.available()>0)
  {
    input[i]=USB.read();
    
    if( (input[i]=='\r') && (input[i]=='\n') )
    {
      input[i]='\0';
    }
    else
    {
      i++;
    }
  }
  
  nRead=i;
  
  if(nRead != numBytes)
  {
    USB.print(F("must write "));
    USB.print(numBytes, DEC);
    USB.print(F(" characters. Read "));     
    USB.print(nRead, DEC);
    USB.println(F(" bytes")); 
    return false;
  }
  else
  {
    input[i]='\0';
    return true;
  }
  
}

void sendWarning()
{
 //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }  

    //////////////////////////////////////////////////
  // 2. Reset to default values
  //////////////////////////////////////////////////
  error = WIFI_PRO.resetValues();

  if (error == 0)
  {    
    USB.println(F("2. WiFi reset to default"));
  }
  else
  {
    USB.println(F("2. WiFi reset to default ERROR"));
  }


  //////////////////////////////////////////////////
  // 3. Set ESSID
  //////////////////////////////////////////////////
  error = WIFI_PRO.setESSID(ESSID);

  if (error == 0)
  {    
    USB.println(F("3. WiFi set ESSID OK"));
  }
  else
  {
    USB.println(F("3. WiFi set ESSID ERROR"));
  }


  //////////////////////////////////////////////////
  // 4. Set password key (It takes a while to generate the key)
  // Authentication modes:
  //    OPEN: no security
  //    WEP64: WEP 64
  //    WEP128: WEP 128
  //    WPA: WPA-PSK with TKIP encryption
  //    WPA2: WPA2-PSK with TKIP or AES encryption
  //////////////////////////////////////////////////
  error = WIFI_PRO.setPassword(WPA2, PASSW);

  if (error == 0)
  {    
    USB.println(F("4. WiFi set AUTHKEY OK"));
  }
  else
  {
    USB.println(F("4. WiFi set AUTHKEY ERROR"));
  }
  
    //////////////////////////////////////////////////
  // 5. Software Reset 
  // Parameters take effect following either a 
  // hardware or software reset
  //////////////////////////////////////////////////
  error = WIFI_PRO.softReset();

  if (error == 0)
  {    
    USB.println(F("5. WiFi softReset OK"));
    WIFI_PRO.setTimeFromWIFI();// set time from WIFI
    USB.println(RTC.getTime());
  }
  else
  {
    USB.println(F("5. WiFi softReset ERROR"));
  }
  
  
  // get current time
  previous = millis();  

 
  //////////////////////////////////////////////////
  // 5. Join AP
  //////////////////////////////////////////////////  

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  { 
    USB.print(F("6. WiFi is connected OK."));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    error = WIFI_PRO.ping("www.google.com");

    if (error == 0)
    {        
      USB.print(F("7. PING OK. Round Trip Time(ms)="));
      USB.println( WIFI_PRO._rtt, DEC );
    }
    else
    {
      USB.println(F("7. Error calling 'ping' function")); 
    }
  }
  else
  {
    USB.print(F("6. WiFi is connected ERROR.")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }

// TCP CLIENT 


 //////////////////////////////////////////////////
  // 8. TCP    CLIENT!!!!
  //////////////////////////////////////////////////  

  // Check if module is connected
  if (status == true)
  {   
    
    //////////////////////////////////////////////// 
    // 8.1. Open TCP socket
    ////////////////////////////////////////////////
    
    error = WIFI_PRO.setTCPclient(HOST, REMOTE_PORT, LOCAL_PORT);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      socket_handle = WIFI_PRO._socket_handle;
      
      USB.print(F("8.1. Open TCP socket OK in handle: "));
      USB.println(socket_handle, DEC);
    }
    else
    {
      USB.println(F("8.1. Error calling 'setTCPclient' function"));
      WIFI_PRO.printErrorCode();
      status = false;   
    }

    if (status == true)
    {   
      ////////////////////////////////////////////////
      // 8.2. send data
      ////////////////////////////////////////////////

      //USB.println(RTC.getTime());

      strcpy(mensaje," \nAn intruder has been detected at ");
      strcat(mensaje,RTC.getTime());


       // uint16_t size = 60;
      error = WIFI_PRO.send( socket_handle, mensaje);//"This is a message from Waspmote  !!\n");

      //mensaje []= "Se ha detectado un intruso a ";

      //error = WIFI_PRO.send( socket_handle, mensaje);//




      
      // BINARY SENDING1
     // uint8_t data[] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37};
     // uint16_t size = 7;
     // error = WIFI_PRO.send( socket_handle, data, size);
      

      // check response
      if (error == 0)
      {
        USB.println(F("8.2. Send data OK"));   
      }
      else
      {
        USB.println(F("8.2. Error calling 'send' function"));
        WIFI_PRO.printErrorCode();       
      }

   
      ////////////////////////////////////////////////
      // 8.3. Wait for answer from server
      ////////////////////////////////////////////////
      USB.println(F("Listen to TCP socket:"));
      error = WIFI_PRO.receive(socket_handle, 300);//30000);

      // check answer  
      if (error == 0)
      {
        USB.println(F("\n========================================"));
        USB.print(F("Data: "));  
        USB.println( WIFI_PRO._buffer, WIFI_PRO._length);

        USB.print(F("Length: "));  
        USB.println( WIFI_PRO._length,DEC);
        USB.println(F("========================================"));
      }

      ////////////////////////////////////////////////
      // 8.4. close socket
      ////////////////////////////////////////////////
      error = WIFI_PRO.closeSocket(socket_handle);

      // check response
      if (error == 0)
      {
        USB.println(F("8.3. Close socket OK"));   
      }
      else
      {
        USB.println(F("8.3. Error calling 'closeSocket' function"));
        WIFI_PRO.printErrorCode(); 
      }
    }
  }

  delay(10000);

  
}


