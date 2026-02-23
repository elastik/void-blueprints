// =============================================================================
// The Void -- BME280 Sensor Reader
// =============================================================================
//
// I2C sensor reader for the BME280 temperature, humidity, and pressure sensor.
// Provides non-blocking read interface with error handling for disconnected
// or malfunctioning sensors.
//
// Uses Adafruit BME280 library. I2C pins are configured from config.h
// (PIN_SDA, PIN_SCL) via Wire.begin() in begin().
//
// =============================================================================

#ifndef VOID_SENSOR_READER_H
#define VOID_SENSOR_READER_H

#include <Adafruit_BME280.h>

// -----------------------------------------------------------------------------
// Sensor Data Struct
// -----------------------------------------------------------------------------

struct SensorData {
    float temperature;       // Celsius
    float humidity;          // % RH
    float pressure;          // hPa
    bool valid;              // true if last reading succeeded
    unsigned long timestamp; // millis() at time of reading
};

// -----------------------------------------------------------------------------
// Sensor Reader Class
// -----------------------------------------------------------------------------

class SensorReader {
public:
    /// Initialize the BME280 sensor over I2C.
    /// Tries address 0x76 first, then falls back to 0x77.
    /// Returns true if sensor was found and configured.
    bool begin();

    /// Take a new reading from the sensor.
    /// Updates the internal SensorData struct.
    /// Returns true if the reading is valid (no NaN values).
    bool read();

    /// Return a const reference to the latest sensor data.
    const SensorData& getData() const;

    /// Return true if the sensor was initialized successfully.
    bool isReady() const;

private:
    Adafruit_BME280 bme;
    SensorData data = {0.0f, 0.0f, 0.0f, false, 0};
    bool initialized = false;
};

#endif // VOID_SENSOR_READER_H
