// =============================================================================
// The Void -- BME280 Sensor Reader Implementation
// =============================================================================

#include "sensor_reader.h"
#include "config.h"
#include <Arduino.h>
#include <Wire.h>

// BME280 I2C addresses
static constexpr uint8_t BME280_ADDR_PRIMARY   = 0x76;
static constexpr uint8_t BME280_ADDR_SECONDARY = 0x77;

bool SensorReader::begin() {
    // Initialize I2C with pins from config.h (ESP32 default: SDA=21, SCL=22)
    Wire.begin(PIN_SDA, PIN_SCL);

    // Try primary address first (most common for Adafruit/generic breakouts)
    if (bme.begin(BME280_ADDR_PRIMARY)) {
        Serial.println("[Sensor] BME280 found at 0x76");
    } else if (bme.begin(BME280_ADDR_SECONDARY)) {
        Serial.println("[Sensor] BME280 found at 0x77");
    } else {
        Serial.println("[Sensor] BME280 not found at 0x76 or 0x77");
        initialized = false;
        return false;
    }

    // Configure oversampling and filter
    // Humidity x2, Temperature x2, Pressure x1, Filter coefficient 4
    bme.setSampling(
        Adafruit_BME280::MODE_NORMAL,
        Adafruit_BME280::SAMPLING_X2,   // temperature
        Adafruit_BME280::SAMPLING_X1,   // pressure
        Adafruit_BME280::SAMPLING_X2,   // humidity
        Adafruit_BME280::FILTER_X4,     // filter coefficient 4
        Adafruit_BME280::STANDBY_MS_1000
    );

    initialized = true;
    Serial.println("[Sensor] BME280 initialized — oversampling: T x2, H x2, P x1, filter x4");
    return true;
}

bool SensorReader::read() {
    if (!initialized) {
        return false;
    }

    float t = bme.readTemperature();
    float h = bme.readHumidity();
    float p = bme.readPressure() / 100.0f; // Pa to hPa

    // Check for NaN — indicates sensor disconnection or communication failure
    if (isnan(t) || isnan(h) || isnan(p)) {
        data.valid = false;
        Serial.println("[Sensor] BME280 read returned NaN — check wiring");
        return false;
    }

    data.temperature = t;
    data.humidity = h;
    data.pressure = p;
    data.valid = true;
    data.timestamp = millis();

    return true;
}

const SensorData& SensorReader::getData() const {
    return data;
}

bool SensorReader::isReady() const {
    return initialized;
}
