#include "script_component.hpp"
SCRIPT(XEH_preInit);
/*
	Basic, Generic Version Checking System - By Sickboy <sb_at_dev-heaven.net>

*/
LOG(MSG_INIT);
ADDON = false;

// Build versions hash
GVAR(versions) = [[], [[0, 0, 0], 0]] call CBA_fnc_hashCreate;
GVAR(dependencies) = [[], ["", [0, 0, 0], "true"]] call CBA_fnc_hashCreate;
private ["_prefix", "_version", "_verCfg", "_level", "_deps", "_dependencies", "_entry"];
for "_i" from 0 to (count (CFGSETTINGS) - 1) do
{
	_prefix = (CFGSETTINGS) select _i;
	if (isClass _prefix) then
	{
		_verCfg = (configFile >> "CfgPatches" >> format["%1_main", configName _prefix] >> "versionAr");
		_level = if (isNumber(_prefix >> "level")) then { getNumber(_prefix >> "level") } else { -1 };
		_version = if (isArray(_verCfg)) then { [getArray(_verCfg), _level] } else { [[0, 0, 0], 0] };
		[GVAR(versions), toLower(configName _prefix), _version] call CBA_fnc_hashSet;
		_deps = (_prefix >> "dependencies");
		if (isClass(_deps)) then {
			_dependencies = [];
			for "_j" from 0 to ((count _deps) - 1) do {
				_entry = _deps select _j;
				if (isArray(_entry)) then {
					PUSH(_dependencies,(getArray(_entry)));
				};
			};
			[GVAR(dependencies), toLower(configName _prefix), _dependencies] call CBA_fnc_hashSet;
		};
	};
};

PREP(version_check);

ADDON = true;
