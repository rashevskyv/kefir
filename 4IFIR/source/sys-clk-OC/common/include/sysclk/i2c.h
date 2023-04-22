#pragma once

#include <switch.h>

// To use i2c service, sm and i2c should be intialized via smInitialize() and i2cInitialize().

Result I2cSet_U8(I2cDevice dev, u8 reg, u8 val);

Result I2cRead_OutU8(I2cDevice dev, u8 reg, u8 *out);
Result I2cRead_OutU16(I2cDevice dev, u8 reg, u16 *out);

// Max17050 fuel gauge
float I2c_Max17050_GetBatteryCurrent();

const u8 MAX17050_CURRENT_REG = 0x0A;

// Buck Converter
typedef enum I2c_BuckConverter_Reg {
    I2c_Max77620_SD1VOLT_REG = 0x17, // Used for Erista DDR VDDQ+VDD2 / Mariko VDD2
    I2c_Max77621_VOLT_REG    = 0x00,
    I2c_Max77812_CPUVOLT_REG = 0x26,
    I2c_Max77812_GPUVOLT_REG = 0x23,
    I2c_Max77812_MEMVOLT_REG = 0x25, // Master 3 (GPU 1 + 2, DRAM 3, CPU 4), used for Mariko VDDQ
} I2c_BuckConverter_Reg;

typedef struct I2c_BuckConverter_Domain {
    I2cDevice device;
    I2c_BuckConverter_Reg reg;
    u8 volt_mask;
    u32 uv_step;
    u32 uv_min;
    u32 uv_max;
    u8 por_val;
} I2c_BuckConverter_Domain;

const I2c_BuckConverter_Domain I2c_Erista_CPU       = { I2cDevice_Max77621Cpu,  I2c_Max77621_VOLT_REG,    0x7F,  6250, 606250, 1400000, };
const I2c_BuckConverter_Domain I2c_Erista_GPU       = { I2cDevice_Max77621Gpu,  I2c_Max77621_VOLT_REG,    0x7F,  6250, 606250, 1400000, };
const I2c_BuckConverter_Domain I2c_Erista_DRAM      = { I2cDevice_Max77620Pmic, I2c_Max77620_SD1VOLT_REG, 0x7F, 12500, 600000, 1250000, };
const I2c_BuckConverter_Domain I2c_Mariko_CPU       = { I2cDevice_Max77812_2,   I2c_Max77812_CPUVOLT_REG, 0xFF,  5000, 250000, 1525000, 0x78 };
const I2c_BuckConverter_Domain I2c_Mariko_GPU       = { I2cDevice_Max77812_2,   I2c_Max77812_GPUVOLT_REG, 0xFF,  5000, 250000, 1525000, 0x78 };
const I2c_BuckConverter_Domain I2c_Mariko_DRAM_VDDQ = { I2cDevice_Max77812_2,   I2c_Max77812_MEMVOLT_REG, 0xFF,  5000, 250000,  650000, 0x78 };
const I2c_BuckConverter_Domain I2c_Mariko_DRAM_VDD2 = { I2cDevice_Max77620Pmic, I2c_Max77620_SD1VOLT_REG, 0x7F, 12500, 600000, 1250000, };

u32 I2c_BuckConverter_GetMvOut(const I2c_BuckConverter_Domain* domain);
Result I2c_BuckConverter_SetMvOut(const I2c_BuckConverter_Domain* domain, u32 mvolt);

// Bq24193 Battery management
u32 I2c_Bq24193_Convert_Raw_mA(u8 raw);
u8  I2c_Bq24193_Convert_mA_Raw(u32 ma);

Result I2c_Bq24193_GetFastChargeCurrentLimit(u32 *ma);
Result I2c_Bq24193_SetFastChargeCurrentLimit(u32 ma);

const u32 MA_RANGE_MIN = 512;
const u32 MA_RANGE_MAX = 4544;

const u8 BQ24193_CHARGE_CURRENT_CONTROL_REG = 0x2;