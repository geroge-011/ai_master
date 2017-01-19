/*aiSpawnInf
	[
		[*spawn logic*,*patrol logic*],						//either a logic or an array of 2 logics
		*spawn distance*,									//number
		*patrol distance*,									//number
		[*side*,*unitArray*],								//west,east,independent,civilian
		[*patrol buildings*,								//bool to enable building patrols and behaviour in qouates
		*stance*,											//https://community.bistudio.com/wiki/setWaypointBehaviour
		*speed*],											//https://community.bistudio.com/wiki/setWaypointSpeed
		*outer spawn*,										//spawn units outside, w/ building patrols units will search buildings around patrol logic
		[*min*,*max*],										//amount of groups to spawn
		[*offencive*,*autoCombat*],							//bool,disable autocombat
		*skill*,											//0 to 1 check aiMaster_skill for more
		[*startCached*,										//bool,
		*limit*,											//active group limit
		*disabled*,											//caching disabled
		*leadfunc*,											//Only leader will remain at double normal distance
		*[close,far]*],										//distances, uncache and cache
		*wave_var*											//wave
	] call fw_fnc_aiSpawnInf;
[base,300,300,[west,2],[true,"SAFE","LIMITED"],false,[5,10],true,0.5,[true,10]] call fw_fnc_aiSpawnInf;
[[opfor1,base],300,300,[east,2],[false,"AWARE","FULL"],false,[5,10],true,0.5,[false,10,true],wave_4] call fw_fnc_aiSpawnInf;
*/
private ["_unit","_it","_unitArray","_gName","_gVars","_unitPos","_patrol","_pos"];
params ["_pos","_dist","_distP","_units","_patrol","_out","_gAmount","_offensive","_skill","_cached","_wave","_customLimit"];
if !(typeName _pos == "ARRAY") then {_pos = [_pos,_pos]};


#include "includes\units.sqf"
if (isNil "_groups")then {_groups = [];};
for "_i" from 1 to ((_gAmount param [0]) + round(random((_gAmount param [1]) - (_gAmount param [0])))) step 1 do {
	_unitArray = call compile format ["_%1_%2",_units param [0],_units param [1]];
	_it = createGroup (_units param [0]);
	_gName = _it;
	_unitPos = [_pos param [0],_dist,[nil, _dist] param [_out]] call BRM_aiMaster_fnc_landPos;
	nul = {
		_unit = _gName createUnit [ _x, _unitPos, [], 20, "NONE" ];
		_unit setVariable ["unit_side", (side _unit)];
		_unit setSkill _skill;
		_unit setskill ["aimingAccuracy",0.4];
		_unit setskill ["aimingSpeed",0.3];
		_unit setskill ["spotTime",0.6];
		_unit disableAI "AUTOCOMBAT";
		_unit setVariable ["aiMaster_cleanUp",true];
		if (side _unit == east) then {[_unit, "AUTO"] call BRM_fnc_initAI;};
		if (side _unit == west) then {[_unit, "AUTO"] call BRM_fnc_initAI;};
		true
	} count _unitArray;
	if (!isNil "_customLimit")then {
		missionNamespace setvariable [_customLimit,(call compile _customLimit+1)];
	};
	_gName setBehaviour (_patrol param [1]);
	_gVars = [
		_gName,													//Group			0
		[_pos param [1],_distP,_patrol,_out],					//Patrol		1
		_cached,												//Cache			2
		[_offensive, nil, nil],									//Fight			3
		_wave,													//Wave			4
		[false,false],											//CacheActive	5
		[],														//cUnits		6
		_customLimit											//CustomLimit	7
	]
	missionNamespace setVariable ["aiMaster_groups",aiMaster_groups append _gVars;];
};
true
