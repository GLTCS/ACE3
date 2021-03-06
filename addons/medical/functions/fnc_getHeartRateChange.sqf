/*
 * Author: Glowbal
 * Get the change in the heart rate. Used for the vitals calculations. Calculated in one seconds.
 *
 * Arguments:
 * 0: The Unit <OBJECT>
 *
 * ReturnValue:
 * Change in heart Rate <NUMBER>
 *
 * Public: No
 */

#include "script_component.hpp"

#define HEART_RATE_MODIFIER 0.02

private ["_unit", "_heartRate", "_hrIncrease", "_bloodLoss", "_time", "_values", "_adjustment", "_change", "_callBack", "_bloodVolume"];
_unit = _this select 0;
_hrIncrease = 0;
if (!(_unit getvariable [QGVAR(inCardiacArrest),false])) then {
    _heartRate = _unit getvariable [QGVAR(heartRate), 80];
    _bloodLoss = [_unit] call FUNC(getBloodLoss);

    _adjustment = _unit getvariable [QGVAR(heartRateAdjustments), []];
    {
        _values = (_x select 0);
        if (abs _values > 0) then {
            _time = (_x select 1);
            _callBack = _x select 2;
            if (_time <= 0) then {
                _time = 1;
            };
            _change = (_values / _time);
            _hrIncrease = _hrIncrease + _change;

            if ( (_time - 1) <= 0) then {
                 _time = 0;
                 _adjustment set [_foreachIndex, ObjNull];
                 [_unit] call _callBack;
            } else {
                _time = _time - 1;
                _adjustment set [_foreachIndex, [_values - _change, _time]];
            };
        } else {
            _adjustment set [_foreachIndex, ObjNull];
            [_unit] call _callBack;
        };

    }foreach _adjustment;
    _adjustment = _adjustment - [ObjNull];
    _unit setvariable [QGVAR(heartRateAdjustments), _adjustment];

    _bloodVolume = _unit getvariable [QGVAR(bloodVolume), 100];
    if (_bloodVolume > 75) then {
        if (_bloodLoss >0.0) then {
            if (_bloodLoss <0.5) then {
                if (_heartRate < 126) then {
                    _hrIncrease = _hrIncrease + 0.05;
                };
            } else {
                if (_bloodLoss < 1) then {
                    if (_heartRate < 161) then {
                        _hrIncrease = _hrIncrease + 0.1;
                    };
                } else {
                    if (_heartRate < 220) then {
                        _hrIncrease = _hrIncrease + 0.15;
                    };
                };
            };
        } else {
            // Stabalize it
            if (_heartRate < (60 + round(random(10)))) then {
                _hrIncrease = _hrIncrease + HEART_RATE_MODIFIER;
            } else {
                if (_heartRate > (77 + round(random(10)))) then {
                    _hrIncrease = _hrIncrease - HEART_RATE_MODIFIER;
                };
            };
        };
    } else {
        _hrIncrease = _hrIncrease - HEART_RATE_MODIFIER;
    };
};
_hrIncrease
