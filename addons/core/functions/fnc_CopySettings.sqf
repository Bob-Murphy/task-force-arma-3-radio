#include "script_component.hpp"

/*
    Name: TFAR_fnc_copySettings

    Author(s):
        L-H

    Description:
        Copies the settings from a radio to another.

    Parameters:
        0:ARRAY/STRING - Source Radio (SW/LR)
        1:ARRAY/STRING - Destination Radio (SW/LR)

    Returns:
        Nothing

    Example:
    // LR - LR
    [(call TFAR_fnc_activeLrRadio),[(vehicle player), "driver"]] call TFAR_fnc_CopySettings;
    // SW - SW
    [(call TFAR_fnc_activeSwRadio),"tf_anprc148jem_20"] call TFAR_fnc_CopySettings;
*/

private ["_settings", "_isDLR", "_isSLR", "_support_additional"];

params ["_source", "_destination"];

_isDLR = if (_destination isEqualType []) then {true}else{false};
_isSLR = if (_source isEqualType []) then {true}else{false};

if (_isSLR) then {
    _settings = _source call TFAR_fnc_GetLRSettings;
    if (_isDLR) then {
        [_destination select 0, _destination select 1,[]+_settings] call TFAR_fnc_SetLRSettings;
    } else {
        diag_log "TFAR - unable to copy from LR to SW";
        hint "TFAR - unable to copy from LR to SW";
    };
} else {
    _settings = _source call TFAR_fnc_GetSwSettings;
    if (!_isDLR) then {
        _settings = []+_settings;
        _support_additional = getNumber (configFile >> "CfgWeapons" >> _destination >> "tf_additional_channel");
        if ((isNil "_support_additional") or {_support_additional == 0}) then {
            _settings set [TF_ADDITIONAL_CHANNEL_OFFSET, -1];
        };
        [_destination, _settings] call TFAR_fnc_SetSwSettings;
    } else {
        diag_log "TFAR - unable to copy from SW to LR";
        hint "TFAR - unable to copy from SW to LR";
    };
};
