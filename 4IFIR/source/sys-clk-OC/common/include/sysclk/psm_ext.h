#pragma once

#include <switch.h>

typedef enum {
    PsmPDC_NewPDO       = 1, //Received new Power Data Object
    PsmPDC_NoPD         = 2, //No Power Delivery source is detected
    PsmPDC_AcceptedRDO  = 3  //Received and accepted Request Data Object
} PsmChargeInfoPDC; //BM92T series

typedef enum {
    PsmPowerRole_Sink      = 1,
    PsmPowerRole_Source    = 2
} PsmPowerRole;

const char* PsmPowerRoleToStr(PsmPowerRole role);

typedef enum {
    PsmInfoChargerType_None         = 0,
    PsmInfoChargerType_PD           = 1,
    PsmInfoChargerType_TypeC_1500mA = 2,
    PsmInfoChargerType_TypeC_3000mA = 3,
    PsmInfoChargerType_DCP          = 4,
    PsmInfoChargerType_CDP          = 5,
    PsmInfoChargerType_SDP          = 6,
    PsmInfoChargerType_Apple_500mA  = 7,
    PsmInfoChargerType_Apple_1000mA = 8,
    PsmInfoChargerType_Apple_2000mA = 9
} PsmInfoChargerType;

const char* PsmInfoChargerTypeToStr(PsmInfoChargerType type);

typedef enum {
    PsmFlags_NoHub  = BIT(0),  //If hub is disconnected
    PsmFlags_Rail   = BIT(8),  //At least one Joy-con is charging from rail
    PsmFlags_SPDSRC = BIT(12), //OTG
    PsmFlags_ACC    = BIT(16)  //Accessory
} PsmChargeInfoFlags;

typedef struct {
    int32_t InputCurrentLimit;          //Input (Sink) current limit in mA
    int32_t VBUSCurrentLimit;           //Output (Source/VBUS/OTG) current limit in mA
    int32_t ChargeCurrentLimit;         //Battery charging current limit in mA (512mA when Docked, 768mA when BatteryTemperature < 17.0 C)
    int32_t ChargeVoltageLimit;         //Battery charging voltage limit in mV (3952mV when BatteryTemperature >= 51.0 C)
    int32_t unk_x10;                    //Possibly an emum, getting the same value as PowerRole in all tested cases
    int32_t unk_x14;                    //Possibly flags
    PsmChargeInfoPDC PDCState;          //Power Delivery Controller State
    int32_t BatteryTemperature;         //Battery temperature in milli C
    int32_t RawBatteryCharge;           //Raw battery charged capacity per cent-mille (i.e. 100% = 100000 pcm)
    int32_t VoltageAvg;                 //Voltage avg in mV (more in Notes)
    int32_t BatteryAge;                 //Battery age (capacity full / capacity design) per cent-mille (i.e. 100% = 100000 pcm)
    PsmPowerRole PowerRole;
    PsmInfoChargerType ChargerType;
    int32_t ChargerVoltageLimit;        //Charger and external device voltage limit in mV
    int32_t ChargerCurrentLimit;        //Charger and external device current limit in mA
    PsmChargeInfoFlags Flags;           //Unknown flags
} PsmChargeInfo;

typedef enum {
  Psm_EnableBatteryCharging      = 2,
  Psm_DisableBatteryCharging     = 3,
  Psm_EnableFastBatteryCharging  = 10,
  Psm_DisableFastBatteryCharging = 11,
  Psm_GetBatteryChargeInfoFields = 17,
} IPsmServerCmd;

bool PsmIsChargerConnected(const PsmChargeInfo* info);
bool PsmIsCharging(const PsmChargeInfo* info);

typedef enum {
    PsmBatteryState_Discharging,
    PsmBatteryState_ChargingPaused,
    PsmBatteryState_FastCharging
} PsmBatteryState;

PsmBatteryState PsmGetBatteryState(const PsmChargeInfo* info);
const char* PsmGetBatteryStateIcon(const PsmChargeInfo* info);