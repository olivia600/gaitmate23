// //Libraries
// #include <LiquidCrystal_I2C.h>
// #include <Wire.h>
// #include <MPU6050.h>
// #include <ArduinoBLE.h>


// const int MPU6050_addr=0x68;
// int16_t AccX,AccY,AccZ,GyroX,GyroY,GyroZ;

// BLEService yourService("180D");  // Use a standard UUID or create your own
// BLEStringCharacteristic yourCharacteristic("2A37", BLERead | BLENotify, 20);

// void setup(){
//   Wire.begin();
//   Wire.beginTransmission(MPU6050_addr);
//   Wire.write(0x6B);
//   Wire.write(0);
//   Wire.endTransmission(true);
//   Serial.begin(9600);

 
//   if (!BLE.begin()) {
//     Serial.println("Starting BLE failed!");
//     while (1);
//   }

//   BLE.setLocalName("My_Exoskeleton");
//   BLE.setAdvertisedService(yourService);
//   yourService.addCharacteristic(yourCharacteristic);
//   BLE.addService(yourService);

//   BLE.advertise();
// }

// void loop(){
//   BLEDevice central = BLE.central();

//   if (central) {
//     Serial.print("Connected to central: ");
//     Serial.println(central.address());

//     while (central.connected()) {
//       // Update your data and notify the central device
//       yourCharacteristic.writeValue("YourDataHere");
//       delay(1000);  // Adjust as needed
//     }

//     Serial.println("Disconnected");
//   }

//   Wire.beginTransmission(MPU6050_addr);
//   Wire.write(0x3B);
//   Wire.endTransmission(false);
//   Wire.requestFrom(MPU6050_addr,14,true);
//   // Reading Acceleration XYZ
//   AccX=Wire.read()<<8|Wire.read(); 
//   AccY=Wire.read()<<8|Wire.read(); 
//   AccZ=Wire.read()<<8|Wire.read(); 
//   // Reading Gyroscope XYZ
//   GyroX=Wire.read()<<8|Wire.read(); 
//   GyroY=Wire.read()<<8|Wire.read(); 
//   GyroZ=Wire.read()<<8|Wire.read(); 
//   // Print Acceleration and Gyroscope Data to Serial Monitor
//   Serial.print("AccX = "); Serial.print(AccX);
//   Serial.print(" || AccY = "); Serial.print(AccY);
//   Serial.print(" || AccZ = "); Serial.print(AccZ);
//   Serial.print(" || GyroX = "); Serial.print(GyroX);
//   Serial.print(" || GyroY = "); Serial.print(GyroY);
//   Serial.print(" || GyroZ = "); Serial.println(GyroZ);
//   delay(100);
// }


