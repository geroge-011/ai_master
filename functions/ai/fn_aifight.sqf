_group = _this;
_leader = leader _this;
_val = _group getVariable "aiMaster_fight";
if ( isNil "_val" ) then {
	_group setVariable ["aiMaster_fight", [false, nil, nil]];
};
_offensive = _val select 0;
_time = _val select 1;
_oldLoc = _val select 2;
if (!_offensive) exitWith { };


if ( !isNil "_time" ) exitWith 
{
	_passed = time - _time;
	if ( _passed < 30 ) exitWith { };
	if ( _passed > 60 ) exitWith {
		_enemySpotted = _leader findNearestEnemy _leader;
		if !( isNull _enemySpotted ) then {
			if ( _enemySpotted distance _leader < 300 ) exitWith { };
		};
		_group setVariable ["aiMaster_fight", [_offensive, _time, _oldLoc]];
		if ( _group in aiMaster_fightingGroups ) then {
			aiMaster_fightingGroups = aiMaster_fightingGroups - [ _group ];
			aiMaster_activeGroups = aiMaster_activeGroups + [ _group ];
		};
	};
};
_findPos = {[(_this select 0),(param [2, 0]), _this select 1, 2, 0, 20, 0] call BIS_fnc_findSafePos};
_enemySpotted = _leader findNearestEnemy _leader;

if ( isNull _enemySpotted || !alive _leader ) exitWith { };
if ((visiblePosition _enemySpotted select 2) > 5) exitWith { };
_knowlage = _group knowsAbout _enemySpotted;
if ( _knowlage < 1 ) exitWith { };
_loc = _leader getHideFrom _enemySpotted;
if ( isNil "_oldLoc" ) then {
	_oldLoc = _loc;
} else {
	if ( _oldLoc distance _loc < 300 ) exitWith { };
};
if (_loc distance [0,0,0] < 100 || _loc distance _leader > 800) exitWith { };
_dist = 50 + (random 300);
_wpPos = [ _loc, _dist ] call _findPos;
if (_wpPos distance [0,0,0] < 100 || _wpPos distance _leader > 800) exitWith { };
if ( _group in aiMaster_activeGroups ) then {
	aiMaster_activeGroups = aiMaster_activeGroups - [ _group ];
	aiMaster_fightingGroups = aiMaster_fightingGroups + [ _group ];
};
while { ( count ( waypoints _group ) ) > 0 } do { deleteWaypoint ( ( waypoints _group ) select 0 ); };
_wp = _group addWaypoint [ _wpPos, 0 ];
_wp setWaypointType "SAD";
_wp setWaypointSpeed _speed;
_group setVariable ["aiMaster_fight", [_offensive, time, _loc]];
true
