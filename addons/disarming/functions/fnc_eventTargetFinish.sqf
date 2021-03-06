/*
 * Author: PabstMirror
 * After FUNC(disarmDropItems) has completed, passing a possible error code.
 * Passes that error back to orginal caller.
 *
 * Arguments:
 * 0: caller <OBJECT>
 * 1: target <OBJECT>
 * 2: errorMsg <STRING>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [player1, player2, "Someting fucked up"] call ace_disarming_fnc_eventTargetFinish
 *
 * Public: No
 */
#include "script_component.hpp"

PARAMS_3(_caller,_target,_errorMsg);

if (_errorMsg != "") then {
    diag_log text format ["[ACE_Disarming] %1 - eventTargetFinish: %2", time, _this];
    ["DisarmDebugCallback", [_caller], [_caller, _target, _errorMsg]] call EFUNC(common,targetEvent);
};
