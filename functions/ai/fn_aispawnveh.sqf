/*aiSpawnVeh
	[
		[*spawn logic*,*patrol logic*],						//either a logic or an array of 2 logics
		*spawn distance*,									//number
		*patrol distance*,									//number
		[*side*,*unitArray*],								//west,east,independent,civilian, true for transport
		[*only roads*,*stance*,*speed*,*trans*],			//bool to enable only roads and behaviour in qouates // https://community.bistudio.com/wiki/setWaypointBehaviour // https://community.bistudio.com/wiki/setWaypointSpeed // tranport ( true )
		*outer spawn*,										//spawn units outside of spawn area, useful for defencive missions, w/ building patrols units will search buildings around patrol logic
		*road spawn*,										//spawn vehicles only on roads
		[*min*,*max*],										//amount of groups to spawn
		*offencive*,										//bool
		*skill*,											//0 to 1 check aiMaster_skill for more
		[*startCached*,*limit*,*disabled*],					//bool, active group limit, caching disabled
		*wave_var*											//wave
	] call fw_fnc_aiSpawnInf;
[base,300,300,[west,2,false],[true,"SAFE","LIMITED"],false,true,[5,10],true,0.5,[true,10]] call fw_fnc_aiSpawnVeh;
[[opfor1,base],300,300,[east,2,true],[false,"AWARE","FULL"],false,false,[5,10],true,0.5,[false,10,true]] call fw_fnc_aiSpawnVeh;
*/
private ["_unit","_it","_unitArray","_gName","_unitPos","_patrol","_pos"];
params ["_pos","_dist","_distP","_units","_patrol","_out","_road","_gAmount","_offensive","_skill","_cached","_wave"];
if !(typeName _pos == "ARRAY") then {_pos = [_pos,_pos]};


#include "includes\vehicles.sqf"
_landPos = {[position (_this select 0),(param [2, 0]), _this select 1, 5, 0, 30, 0] call BIS_fnc_findSafePos};

if (isNil "_groupsVeh")then {_groupsVeh = [];};
for "_i" from 1 to ((_gAmount select 0) + round(random((_gAmount select 1) - (_gAmount select 0)))) step 1 do {
	_unitArray = call compile format ["_%1_%2",_units select 0,_units select 1];
	_it = createGroup (_units select 0);
	_gName = _it;
	_unitPos = [_pos select 0,_dist,[nil, _dist] select _out] call BRM_aiMaster_fnc_landPos;
	_vehPos = [_pos select 0,_dist] call BRM_aiMaster_fnc_roadPos;
	_vehPos2 = [_vehPos,30] call BRM_aiMaster_fnc_roadPos;
	_setPos = position _vehPos;
	_dir = ([_vehPos, _vehPos2] call BIS_fnc_dirTo);
	if ( !_road ) then {
		_vehPos = [_pos select 0,_dist,[nil, _dist] select _out] call _landPos;
		_vehPos2 = [_pos select 0,_dist,[nil, _dist] select _out] call _landPos;
		_setPos = _vehPos;
		_dir = random 360;
	};
	if (isNil "_vehPos" || _vehPos distance [0,0,0] < 100) then { _vehPos = _unitPos; };
	_veh = _unitArray select 0;
	//_veh = [position _vehPos, (random 360), _veh, (_units select 0)] call bis_fnc_spawnvehicle;
	_vehicle = _veh createVehicle _setPos;
	_vehicle setDir _dir;
	_unitArray = _unitArray - [ _unitArray select 0 ];
	_turrets = allTurrets _vehicle;
	if (isNil "_vehicle") exitWith {diag_log "!!!!!!!!!!!!!!!!!!! aiSpawnVeh ERROR VEHICLE IS NIL !!!!!!!!!!!!!!!!!!!";};
	nul = {
		_unit = _gName createUnit [ _x, position _vehicle, [], 20, "NONE" ];
		_unit setVariable ["unit_side", (side _unit)];
		_unit setSkill _skill;
		_unit setskill ["aimingAccuracy",0.4];
		call {
			if (isNull (assignedDriver _vehicle)) exitWith {
				_unit moveInDriver _vehicle;
				_unit setskill ["aimingAccuracy",0.4];
			};
			if ((_vehicle emptyPositions "Gunner") > 0) exitWith {
				_unit moveInGunner _vehicle;
				_unit setskill ["aimingAccuracy",0.4];
			};
			if ((_vehicle emptyPositions "Commander") > 0) exitWith {
				_unit moveInCommander _vehicle;
				_unit setskill ["aimingAccuracy",0.4];
			};
			if (count _turrets > 0) exitWith {
				_unit moveInTurret [_vehicle,(_turrets select 0)];
				_turrets = _turrets - [ (_turrets select 0) ];
				_unit setskill ["aimingAccuracy",0.4];
			};
			if ((_vehicle emptyPositions "cargo") > 0) exitWith {
				_unit moveInCargo _vehicle;
				_unit setskill ["aimingAccuracy",0.4];
			};
		};
		_unit setskill ["aimingSpeed",0.25];
		_unit setskill ["spotTime",0.6];
		//[_unit, "MARINES"] call BRM_fnc_initAI;
		true
	} count _unitArray;
	_gName setBehaviour (_patrol select 1);
	missionNamespace setVariable ["aiMaster_groupsVeh",aiMaster_groupsVeh + [_gName]];
	_it setVariable ["aiMaster_patrolVeh",[_pos select 1,_distP,_patrol,_out]];
	_it setVariable ["aiMaster_cacheVeh",_cached];
	_it setVariable ["aiMaster_fightVeh",[_offensive, nil, nil]];
	if (!isNil "_wave")then {
		_it setVariable ["aiMaster_wave",_wave];
	};
	_noGun = false;
	if (isNull gunner _vehicle) then {_noGun = true;};
	_it setVariable ["aiMaster_vehGun",_noGun];
};
true

/*
position player params ["_x", "_y"]; 
player setPos [_x, _y, 100];

_z = position player param [2, 0];
if (_z > 10) then {
	hint "YOU ARE FLYING!";
};*/
