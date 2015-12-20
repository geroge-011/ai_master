_group = _this;
_val = _group getVariable "aiMaster_patrol";
_loc = _val select 0;
_dist = _val select 1;
_building = ( _val select 2 ) select 0;
_stance = ( _val select 2 ) select 1;
_speed = ( _val select 2 ) select 2;
if ( _building ) exitWith { _group call BRM_aiMaster_fnc_buildingPatrols; };
_oldWP = waypointPosition [ _group, currentWaypoint _group ];
if ( ( getpos leader _group distance _oldWP < 5 || _oldWP distance [ 0, 0, 0 ] < 10 ) && alive leader _group ) then {
	//_group setBehaviour _stance;
	while { ( count ( waypoints _group ) ) > 0 } do { deleteWaypoint ( ( waypoints _group ) select 0 ); };
	//deleteWaypoint [ _group, all ];
	_wpPos = [ _loc, _dist ] call BRM_aiMaster_fnc_landPos;
	_wp = _group addWaypoint [ _wpPos, 0 ];
	_wp setWaypointSpeed _speed; 
	_wp setWaypointBehaviour _stance;
};
true
