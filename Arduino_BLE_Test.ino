/*
 * ARDUINO BLUETOOTH CONNECTION TEST
 * This code ONLY tests Bluetooth connection
 * No motors, no sensors, no Pololu communication
 */

#include <ArduinoBLE.h>

// ============================================
// CONFIGURATION
// ============================================
#define DEVICE_NAME "MOHAMED_ARDUINO" // Change this to whatever you want!
#define STATUS_LED LED_BUILTIN      // Built-in LED for visual feedback

// ============================================
// BLUETOOTH SETUP
// ============================================
BLEService testService("19B10000-E8F2-537E-4F6C-D104768A1214"); // Characteristic UUID (different from service UUID)
BLEStringCharacteristic commandCharacteristic("19B10001-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite, 20); 
// BLERead | BLEWrite = MATLAB can read AND write to this
//  20 = Maximum string length (20 characters)

// ============================================
// VARIABLES
// ============================================
unsigned long connectionTime = 0;
int connectionCount = 0;
bool isConnected = false;

// ============================================
// SETUP FUNCTION 
// ============================================
void setup()
{
    // Initialize Serial for debugging (Serial Monitor)
    Serial.begin(9600);
    while (!Serial)
        ; // Wait for Serial Monitor to open

    Serial.println("\n========================================");
    Serial.println("BLUETOOTH CONNECTION TEST");
    Serial.println("========================================");

    // Initialize status LED
    pinMode(STATUS_LED, OUTPUT);
    digitalWrite(STATUS_LED, LOW);

    // TEST 1: Initialize BLE
    Serial.println("\n[TEST 1] Initializing Bluetooth...");
    if (!BLE.begin())
    {
        Serial.println("FAILED: Cannot initialize Bluetooth!");;
        blinkError(5); // Fast blink indicates error
        while (1)
            ; // Stop here if BLE fails
    }
    Serial.println("SUCCESS: Bluetooth hardware initialized");

    // TEST 2: Set device name
    Serial.println("\n[TEST 2] Setting device name...");
    BLE.setLocalName(DEVICE_NAME);
    Serial.print("Device name set to: ");
    Serial.println(DEVICE_NAME);

    // TEST 3: Set up service
    Serial.println("\n[TEST 3] Setting up BLE service...");
    BLE.setAdvertisedService(testService); // Tells Bluetooth which service to advertise
                                           // MATLAB scans for devices advertising this specific service

    testService.addCharacteristic(commandCharacteristic); // Links the characteristic to the service
    BLE.addService(testService); // What it does: Registers the service with the BLE stack, Makes the service available for connections
    Serial.println("BLE service configured");


    // TEST 4: Start advertising
    Serial.println("\n[TEST 4] Starting advertisement...");
    BLE.advertise(); //  Starts broadcasting "I'm available!" , Without this, MATLAB can't find your Arduino
    Serial.println("Now advertising as Bluetooth device");

    Serial.println("\n========================================");
    Serial.println("READY FOR CONNECTION");
    Serial.println("========================================");
    Serial.print("Device Name: ");
    Serial.println(DEVICE_NAME);
    Serial.println("Waiting for MATLAB connection...");
    Serial.println("========================================");

    // Blink 3 times to indicate ready
    for (int i = 0; i < 3; i++)
    {
        digitalWrite(STATUS_LED, HIGH);
        delay(200);
        digitalWrite(STATUS_LED, LOW);
        delay(200);
    }
}

// ============================================
// HELPER FUNCTIONS
// ============================================
void blinkError(int times)
{
    for (int i = 0; i < times; i++)
    {
        digitalWrite(STATUS_LED, HIGH);
        delay(100);
        digitalWrite(STATUS_LED, LOW);
        delay(100);
    }
}

void printConnectionInfo(BLEDevice central)
{
    Serial.println("\n=== CONNECTION ESTABLISHED ===");
    Serial.print("Connected to: ");
    Serial.println(central.address());
    Serial.print("Local name: ");
    Serial.println(central.localName());
    Serial.print("RSSI: ");
    Serial.println(central.rssi());
    Serial.println("==============================");
}

// ============================================
// MAIN LOOP 
// ============================================
void loop()
{
    // Wait for a Bluetooth connection
    BLEDevice central = BLE.central();

    if (central)
    {
        // New connection
        if (!isConnected)
        {
            isConnected = true;
            connectionCount++;
            connectionTime = millis();
            printConnectionInfo(central);

            // LED solid when connected
            digitalWrite(STATUS_LED, HIGH);
        }

        // While connected to central
        while (central.connected()) // while the Arduino is connected via Bleutooth
        {
            // Check if MATLAB sends a command
            if (commandCharacteristic.written())
            {
                String command = commandCharacteristic.value();

                Serial.print("\n📨 Command received: ");
                Serial.println(command);

                // Handle test commands
                if (command == "TEST")
                {
                    Serial.println("TEST command acknowledged");
                    Serial.println("Bluetooth connection is working!");
                }
                else if (command == "DRIVE")
                {
                    Serial.println("Start driving forward ...");
                }
                else if (command == "STATUS")
                {
                    Serial.println("\n=== CURRENT STATUS ===");
                    Serial.print("Connection time: ");
                    Serial.print((millis() - connectionTime) / 1000);
                    Serial.println(" seconds");
                    Serial.print("Total connections: ");
                    Serial.println(connectionCount);
                    Serial.println("======================");
                }
                else if (command == "STOP")
                {
                    Serial.println("🔌 Motor is stopped!");
                }
                else
                {
                    Serial.print("Unknown command: ");
                    Serial.println(command);
                    Serial.println("Try: TEST, PING, STATUS, DISCONNECT");
                }
            }

            // Small delay to prevent CPU overload
            delay(100);
        }

        // Disconnected
        if (isConnected)
        {
            isConnected = false;
            Serial.print("\n🔌 Disconnected from: ");
            Serial.println(central.address());
            Serial.print("Connection duration: ");
            Serial.print((millis() - connectionTime) / 1000);
            Serial.println(" seconds");
            Serial.println("Waiting for new connection...");

            // LED off when disconnected
            digitalWrite(STATUS_LED, LOW);
        }
    }

    // If not connected, slow blink to indicate waiting
    if (!isConnected)
    {
        static unsigned long lastBlink = 0;
        if (millis() - lastBlink > 1000)
        {
            digitalWrite(STATUS_LED, !digitalRead(STATUS_LED));
            lastBlink = millis();
        }
    }
}
