/*aiSpawnInf
	[
		[*spawn logic*,*patrol logic*],						//either a logic or an array of 2 logics
		*spawn distance*,									//number
		*patrol distance*,									//number
		[*side*,*unitArray*],								//west,east,independent,civilian
		[*patrol buildings*,*stance*,*speed*],				//bool to enable building patrols and behaviour in qouates // https://community.bistudio.com/wiki/setWaypointBehaviour // https://community.bistudio.com/wiki/setWaypointSpeed //
		*outer spawn*,										//spawn units outside of spawn area, useful for defencive missions, w/ building patrols units will search buildings around patrol logic
		[*min*,*max*],										//amount of groups to spawn
		*offencive*,										//bool
		*skill*,											//0 to 1 check aiMaster_skill for more
		[*startCached*,*limit*,*disabled*],					//bool, active group limit, caching disabled
		*wave_var*											//wave
	] call fw_fnc_aiSpawnInf;
[base,300,300,[west,2],[true,"SAFE","LIMITED"],false,[5,10],true,0.5,[true,10]] call fw_fnc_aiSpawnInf;
[[opfor1,base],300,300,[east,2],[false,"AWARE","FULL"],false,[5,10],true,0.5,[false,10,true],wave_4] call fw_fnc_aiSpawnInf;
*/
private ["_unit","_it","_unitArray","_gName","_unitPos","_patrol","_pos"];
params ["_pos","_dist","_distP","_units","_patrol","_out","_gAmount","_offensive","_skill","_cached","_wave"];
if !(typeName _pos == "ARRAY") then {_pos = [_pos,_pos]};


#include "includes\units.sqf"
if (isNil "_groups")then {_groups = [];};
for "_i" from 1 to ((_gAmount select 0) + round(random((_gAmount select 1) - (_gAmount select 0)))) step 1 do {
	_unitArray = call compile format ["_%1_%2",_units select 0,_units select 1];
	_it = createGroup (_units select 0);
	_gName = _it;
	_unitPos = [_pos select 0,_dist,[nil, _dist] select _out] call BRM_aiMaster_fnc_landPos;
	nul = {
		//_unit = _x createUnit [ _unitPos, _gName ];
		_unit = _gName createUnit [ _x, _unitPos, [], 20, "NONE" ];
		_unit setVariable ["unit_side", (side _unit)];
		_unit setSkill _skill;
		_unit setskill ["aimingAccuracy",0.4];
		_unit setskill ["aimingSpeed",0.3];
		_unit setskill ["spotTime",0.6];
		//[_unit, "MARINES"] call BRM_fnc_initAI;
		true
	} count _unitArray;
	_gName setBehaviour (_patrol select 1);
	missionNamespace setVariable ["aiMaster_groups",aiMaster_groups + [_gName]];
	_it setVariable ["aiMaster_patrol",[_pos select 1,_distP,_patrol,_out]];
	_it setVariable ["aiMaster_cache",_cached];
	_it setVariable ["aiMaster_fight",[_offensive, nil, nil]];
	if (!isNil "_wave")then {
		_it setVariable ["aiMaster_wave",_wave];
	};
};
true

/*
position player params ["_x", "_y"]; 
player setPos [_x, _y, 100];

*/
