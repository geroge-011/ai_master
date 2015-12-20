_loc = _this select 0;
_dist = _this select 1;
_house = _this select 2;



_buildingsArray = nearestObjects [_loc, ["building"], _dist];


if ( isNil "_house" ) then {
	_house = while { count _buildingsArray > 0 } do {
		_num = floor (random (count _buildingsArray));
		_ent = [ _buildingsArray select _num , 2] call BIS_fnc_isBuildingEnterable;
		if ( _ent && !( _ent in aiMaster_patrolHouses ) ) exitWith {_buildingsArray select _num};
		_buildingsArray = _buildingsArray - [ _buildingsArray select _num ];
	};
};
if ( isNil "_house" ) exitWith { nil };
_buildingPos = _house call BIS_fnc_buildingPositions;
if ( count _buildingPos < 5 ) then {
	aiMaster_patrolHouses = aiMaster_patrolHouses + [ _house ];
};
[ ( _house call BIS_fnc_buildingPositions ), _house ]
