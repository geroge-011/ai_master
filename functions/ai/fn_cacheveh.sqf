_group = _this;
if ( !alive leader _group ) exitWith {};
_vehicle = assignedVehicle leader _group;
_val = _group getVariable "aiMaster_cacheVeh";
if ( isNil "_val" ) then {
	_group setVariable ["aiMaster_cacheVeh",[true,15]];
	_val = [false,15];
};
_start = _val select 0;
_max = _val select 1;
_no = _val select 2;
_wave = _group getVariable "aiMaster_wave";
_wave = call compile _wave;

if ( isNil "_no" ) then {
	_no = false;
};

_distClose = 1500;
_distFar = 1600;

_patrol = _group getVariable "aiMaster_patrolVeh";
_loc = _patrol select 0;
_dist = _patrol select 1;
if ((leader _group distance _loc) > (_dist + _dist / 2)) then { 
	_distClose = _distClose * 3;
	_distFar = _distFar * 3;
};

if ( _no ) exitWith { if !(_group in aiMaster_activeGroupsVeh) then { aiMaster_activeGroupsVeh = aiMaster_activeGroupsVeh + [ _group ];}; };

_speak = _group getVariable "aiMaster_speak";
if ( isNil "_speak" ) then {
	_speak = speaker leader _group;
	_group setVariable ["aiMaster_speak", _speak];
};

_cache = {
	{
		[0, {_this enableSimulationGlobal false;}, _x] call CBA_fnc_globalExecute;
		[0, {_this hideObjectGlobal true;}, _x] call CBA_fnc_globalExecute;
		_x setSpeaker "NoVoice";
	} count units _this;
	[0, {_this enableSimulationGlobal false;}, _vehicle] call CBA_fnc_globalExecute;
	[0, {_this hideObjectGlobal true;}, _vehicle] call CBA_fnc_globalExecute;
};
_unCache = {
	{
		[0, {_this enableSimulationGlobal true;}, _x] call CBA_fnc_globalExecute;
		[0, {_this hideObjectGlobal false;}, _x] call CBA_fnc_globalExecute;
		_x setSpeaker _speak;
	} count units _this;
	[0, {_this enableSimulationGlobal true;}, _vehicle] call CBA_fnc_globalExecute;
	[0, {_this hideObjectGlobal false;}, _vehicle] call CBA_fnc_globalExecute;
};
if (!isNil "_wave") then {
	if ( !_wave ) exitWith {
		if !(_group in aiMaster_cachedGroupsVeh) then {
			_group call _cache;
			aiMaster_cachedGroupsVeh = aiMaster_cachedGroupsVeh + [_group];
		};
	};
	_distClose = _distClose + (_distClose / 2);
	_distFar = _distFar + (_distFar / 2);
};

if (!(_group in aiMaster_activeGroupsVeh) && !(_group in aiMaster_cachedGroupsVeh) && !(_group in aiMaster_fightingGroupsVeh)) exitWith {
	if ( _start ) then {
		_group setVariable ["aiMaster_cacheVeh",[false,_max]];
		_group call _cache;
		aiMaster_cachedGroupsVeh = aiMaster_cachedGroupsVeh + [ _group ];
	} else {
		aiMaster_activeGroupsVeh = aiMaster_activeGroupsVeh + [ _group ];
	};
};

if (isNil "_wave") then {_wave = true;};
if (!_wave) exitWith { };

_players = allPlayers;
_leader = leader _group;
_close = false;

if ( _group in aiMaster_cachedGroupsVeh ) then {
	if ( count aiMaster_activeGroupsVeh > _max ) exitWith { };
	{
		_dist = _x distance _leader;
		if ( _dist < _distClose ) exitWith { _close = true; };
	} count _players;
	if ( _close ) exitWith {
	_tooClose = false;
	{
		_dist = _x distance _leader;
		if ( _dist < 500 ) exitWith { _tooClose = true; };
	} count _players;
	if ( _tooClose ) exitWith { };	
		_group call _unCache;
		aiMaster_activeGroupsVeh = aiMaster_activeGroupsVeh + [ _group ];
		aiMaster_cachedGroupsVeh = aiMaster_cachedGroupsVeh - [ _group ];
	};
};
if ( _group in aiMaster_activeGroupsVeh ) then {
	{
		if ( _x distance _leader < _distFar ) exitWith { _close = true; };
	} count _players;
	if ( _close ) exitWith { };
	_group call _cache;
	aiMaster_cachedGroupsVeh = aiMaster_cachedGroupsVeh + [ _group ];
	aiMaster_activeGroupsVeh = aiMaster_activeGroupsVeh - [ _group ];
};
true
