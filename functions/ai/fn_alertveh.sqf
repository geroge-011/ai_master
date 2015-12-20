private ["_group","_leader","_vehicle","_var","_loc","_dist","_patrol","_out","_building","_stance","_speed","_oldStance","_xOldStance","_xStance"];
_group = _this;
_leader = leader _group;
_vehicle = assignedVehicle leader _group;
_var = _group getVariable "aiMaster_patrolVeh";
_loc = _var select 0;
_dist = _var select 1;
_patrol = _var select 2;
_out = _var select 3;
_building = _patrol select 0;
_stance = _patrol select 1;
_speed = _patrol select 2;
_oldStance = _patrol select 3;
if ( isNil "_oldStance" || typeName _oldStance == "BOOL") then {
	_oldStance = _stance;
};

_val = _group getVariable "aiMaster_alertVeh";
if ( isNil "_val" ) then {
	_group setVariable ["aiMaster_alertVeh",[false,0]];
	_val = [false,0];
};
_alert = _val select 0;
_time = _val select 1;

if ( _alert ) exitWith {
	_passed = time - _time;
	if ( _passed > 600 ) then {
		_group setBehaviour _oldStance;
		_group setVariable ["aiMaster_alertVeh",[false, 0]];
		_x setVariable ["aiMaster_patrolVeh",[_loc,_dist, [ _building, _oldStance, _speed ],_out]];
	};
};





_enemySpotted = _leader findNearestEnemy _leader;
if ( isNull _enemySpotted || !alive _leader ) exitWith { };
//if ( lineIntersects [ eyepos _leader, eyePos _enemySpotted ] || terrainIntersect [ eyePos _leader, eyepos _enemySpotted ] ) exitWith { };
_knowlege = _group knowsAbout _enemySpotted;
if ( _knowlege < 1 ) exitWith { };
_group setVariable ["aiMaster_alertVeh",[true,time]];
if ((_enemySpotted distance _vehicle) < 100) then {
	if (isNull gunner _vehicle) then {
		(driver _vehicle) action ["Getout",_vehicle];
		(driver _vehicle) action ["Eject",_vehicle];
	};
};
{
	if ( (alive leader _x) && (leader _x distance _leader < 1000) && ( _group != _x ) && ( side _leader == side leader _x ) ) then {
		_xGroup = _x;
		_xLeader = leader _xGroup;
		_xVar = _x getVariable "aiMaster_patrol";
		_xLoc = _xVar select 0;
		_xDist = _xVar select 1;
		_xPatrol = _xVar select 2;
		_xOut = _xVar select 3;
		_xBuilding = _xPatrol select 0;
		_xStance = _xPatrol select 1;
		_xSpeed = _xPatrol select 2;
		_xOldStance = _xPatrol select 3;
		if ( isNil "_xOldStance" ) then {
			_xOldStance = _xStance;
		};
		if ( (_xLeader distance _leader < 400) && (side _x == side _leader) ) then {
			_xLeader setBehaviour "COMBAT";
			_x reveal [_enemyspotted,_knowlege];
			_xGroup setVariable ["aiMaster_alert",[true,time]];
			_xGroup setVariable ["aiMaster_patrol",[_xLoc,_xDist,[ _xBuilding,"COMBAT",_xSpeed,_xOldStance],_xOut]];
		} else {
			_xLeader setBehaviour "AWARE";
			_xGroup setVariable ["aiMaster_alert",[true,time]];
			_xGroup setVariable ["aiMaster_patrol",[_xLoc,_xDist,[_xBuilding,"AWARE",_xSpeed,_xOldStance],_xOut]];
		};
	};
} count aiMaster_activeGroups;
{
	if ( (alive leader _x) && (leader _x distance _leader < 1500) && ( _group != _x ) && ( side _leader == side leader _x ) ) then {
		_xGroup = _x;
		_xLeader = leader _xGroup;
		_xVar = _x getVariable "aiMaster_patrolVeh";
		_xLoc = _xVar select 0;
		_xDist = _xVar select 1;
		_xPatrol = _xVar select 2;
		_xOut = _xVar select 3;
		_xBuilding = _xPatrol select 0;
		_xStance = _xPatrol select 1;
		_xSpeed = _xPatrol select 2;
		_xOldStance = _xPatrol select 3;
		if ( isNil "_xOldStance" ) then {
			_xOldStance = _xStance;
		};
		if ( (_xLeader distance _leader < 750) && (side _x == side _leader) ) then {
			_xLeader setBehaviour "COMBAT";
			_x reveal [_enemyspotted,_knowlege];
			_xGroup setVariable ["aiMaster_alertVeh",[true,time]];
			_xGroup setVariable ["aiMaster_patrolVeh",[_xLoc,_xDist,[ _xBuilding,"COMBAT",_xSpeed,_xOldStance],_xOut]];
		} else {
			_xLeader setBehaviour "AWARE";
			_xGroup setVariable ["aiMaster_alertVeh",[true,time]];
			_xGroup setVariable ["aiMaster_patrolVeh",[_xLoc,_xDist,[_xBuilding,"AWARE",_xSpeed,_xOldStance],_xOut]];
		};
	};
} count aiMaster_activeGroupsVeh;
true
