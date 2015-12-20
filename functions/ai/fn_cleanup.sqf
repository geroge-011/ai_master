//call fw_fnc_cleanUp;
//
//
clean_up_min = 10;
clean_up_distanceToPlayer = 150;
_array = allDeadMen;
_players = allPlayers;
_deadVehicles = allDead - _array;
{
	_close = false;
	_num = count _array;
	if (_num > clean_up_min) then {
		_dead = _x;
		_var = _x getVariable "aiMaster_dead";
		if (!isNil "_var") then {
			if (_var) then { _dead setVariable [ "aiMaster_dead", false ]; };
			if (!_var) then { deleteVehicle _dead; _array = _array - [_dead];};
		} else {
			if (_num > 30) then { deleteVehicle _dead; _array = _array - [_dead];
			} else {
				{
					if (_dead distance _x < clean_up_distanceToPlayer) exitWith { _dead setVariable [ "aiMaster_dead", true ]; _close = true;};
				} count _players;
				if (!_close && _num > clean_up_min) then { deleteVehicle _dead; _array = _array - [_dead]; };
			};
		};
	};
} count _array;
//
{
	_close = false;
	_num = count _deadVehicles;
	if (_num > 5) then {
		_dead = _x;
		_var = _x getVariable "aiMaster_dead";
		if (!isNil "_var") then {
			if (_var) then { _dead setVariable [ "aiMaster_dead", false ]; };
			if (!_var) then { deleteVehicle _dead; _deadVehicles = _deadVehicles - [_dead];};
		} else {
			if (_num > 10) then { deleteVehicle _dead; _deadVehicles = _deadVehicles - [_dead];
			} else {
				{
					if (_dead distance _x < 300) exitWith { _dead setVariable [ "aiMaster_dead", true ]; _close = true;};
				} count _players;
				if (!_close && _num > 3) then { deleteVehicle _dead; _deadVehicles = _deadVehicles - [_dead]; };
			};
		};
	};
} count _deadVehicles;
