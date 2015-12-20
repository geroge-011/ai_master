//_group call fw_fnc_buildingPatrols;
//
//
_group = _this;
_val = _group getVariable "aiMaster_patrol";
_loc = _val select 0;
_dist = _val select 1;
_patrol = _val select 2;
_out = _val select 3;
_building = _patrol select 0;
_stance = _patrol select 1;
_speed = _patrol select 2;
_buildingPatrol = _group getVariable "aiMaster_buildingPatrol";
_first = false;

if ( !alive leader _group ) exitWith { };

if ( isNil "_buildingPatrol" ) then {
	//_group setVariable ["aiMaster_buildingPatrol",[1,time]];
	_buildingPatrol = [ 0, 0, nil ];
	_first = true;
};

_loops = _buildingPatrol select 0;
if (_out) then { _loops = _loops + 25 };
_time = _buildingPatrol select 1;
_building = _buildingPatrol select 2;
_passed = time - _time;

if ( !_first && _loops < 10 + ( ceil (random 30 ) ) ) exitWith {
	if ( !_first && _passed < ( 60 + random ( 100 ) ) ) exitWith { };
	if ( _building distance leader _group > 50) exitWith { };
	_group setVariable [ "aiMaster_buildingPatrol", [ _loops + 1, _time, _building ] ];
	_buildingPos = _building call BIS_fnc_buildingPositions;
	_nul = {
		if ( alive _x ) then {
			if ( count _buildingPos == 0 ) exitWith { };
			_num = floor (random ( count _buildingPos ) );
			_wpPos = _buildingPos select _num;
			//_wpPos = [ _wpPos select 0, _wpPos select 1, ( _wpPos select 2 ) ];
			_x doMove _wpPos;
			_group setBehaviour _stance;
			_buildingPos = _buildingPos - [ _wpPos ];
		};
		true
	} count units _group;
};

_building = nil;
_array = [ _loc, _dist, _building ] call BRM_aiMaster_fnc_buildingPos;
if ( isNil "_array" ) exitWith { _group setVariable ["aiMaster_patrol",[_loc,_dist, [ false, _stance, _speed ],_out]]; }; 
_posArray = _array select 0;
_building = _array select 1;


while { ( count ( waypoints _group ) ) > 0 } do { deleteWaypoint ( ( waypoints _group ) select 0 ); };
//_wp = _group addWaypoint [ _wpPos, 0 ];
[_group, 1] setWaypointSpeed _speed;
_group setVariable ["aiMaster_buildingPatrol",[1,time,_building]];
{
	if ( count _posArray == 0 ) exitWith {};
	_wpPos = _posArray call BIS_fnc_selectRandom;
	_posArray = _posArray - [_wpPos];
	//_wpPos = [ _wpPos select 0, _wpPos select 1, _wpPos select 2 ];
	_x doMove _wpPos;
} count units _group;
true
