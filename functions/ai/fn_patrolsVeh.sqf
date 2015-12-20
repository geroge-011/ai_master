_group = _this;
_vehicle = assignedVehicle leader _group;
_val = _group getVariable "aiMaster_patrolVeh";
_loc = _val select 0;
_dist = _val select 1;
_out = _val select 3;
_road = ( _val select 2 ) select 0;
_stance = ( _val select 2 ) select 1;
_speed = ( _val select 2 ) select 2;
_trans = ( _val select 2 ) select 3;

_load = true;
_time = 0;
_unloaded = false;
_val = _group getVariable "aiMaster_vehLoaded";
if (!isNil "_val") then {
	_load = _val select 0;
	_time = _val select 1;
	_gotOut = _val select 2;
	if (!_load && !isNil "_vehicle") then {
		if (!isNull _vehicle) then {
			_loc = _vehicle;
			_dist = _dist / 2;
		};
	};
};
if (_time > 0) then {_unloaded = true;};





//if ( _building ) exitWith { _group call fw_fnc_buildingPatrols; };
_oldWP = waypointPosition [ _group, currentWaypoint _group ];
if ( ( getpos leader _group distance _oldWP < 5 || _oldWP distance [ 0, 0, 0 ] < 10 ) && alive leader _group ) then {
	if (!isNil "_gotOut") exitWith {
		_group setVariable ["aiMaster_patrol",[_loc,_dist,[false,_stance,_speed],_out]];
		aiMaster_activeGroups = aiMaster_activeGroups + [ _group ];
		if (_group in aiMaster_activeGroupsVeh) then {aiMaster_activeGroupsVeh = aiMaster_activeGroupsVeh - [ _group ];};
	};
	//_group setBehaviour _stance;
	while { ( count ( waypoints _group ) ) > 0 } do { deleteWaypoint ( ( waypoints _group ) select 0 ); };
	//deleteWaypoint [ _group, all ];
	_wpPos = [ _loc, _dist ] call BRM_aiMaster_fnc_roadPos;
	_wpPos = position _wpPos;
	if ( !_road ) then {
		_wpPos = [ _loc, _dist ] call BRM_aiMaster_fnc_landPos;
	};
	if (isNil "_wpPos") exitWith {};
	_wp = _group addWaypoint [ _wpPos, 0 ];
	_wp setWaypointSpeed _speed;
	_wp setWaypointBehaviour _stance;
	
	if ( _trans ) exitWith {
		_wp setWaypointType "GETOUT";
		_group setVariable ["aiMaster_vehLoaded",[false,time,true]];
	};
	if ( _load ) exitWith {
		_wp setWaypointType "UNLOAD";
		_group setVariable ["aiMaster_vehLoaded",[false,time]];
	};
	if (!_unloaded) exitWith { };
	if (_passed > 120 + (random 300)) then {
		_wp setWaypointType "LOAD";
		_group setVariable ["aiMaster_vehLoaded",[true,0]];
	};
};
true
