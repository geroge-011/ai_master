//AI MASTER
//
//
asr_ai3_main_enabled = 0;
0 spawn {
	uiSleep 10;
	while {isNil "mission_AI_controller_name"} do {uiSleep 1;};
	if !(mission_ai_controller) exitWith { };
	aiMaster_groups = [ ];
	aiMaster_cachedGroups = [ ];
	aiMaster_activeGroups = [ ];
	aiMaster_fightingGroups = [ ];
	//
	aiMaster_groupsVeh = [ ];
	aiMaster_cachedGroupsVeh = [ ];
	aiMaster_activeGroupsVeh = [ ];
	aiMaster_fightingGroupsVeh = [ ];
	call BRM_aiMaster_fnc_spawnUnits;
	uiSleep 10;
	//waitUntil { count aiMaster_groups > 0 };
	aiMaster_debug = 0;
	aiMasterLoopRun = 0;
	aiMasterLoop = [ {
		aiMaster_debug = aiMaster_debug + 1;
		publicVariable "aiMaster_debug";
		_groups = aiMaster_groups;
		_cachedGroups = aiMaster_cachedGroups;
		_activeGroups = aiMaster_activeGroups;
		_fightingGroups = aiMaster_fightingGroups;
		//
		_groupsVeh = aiMaster_groupsVeh;
		_cachedGroupsVeh = aiMaster_cachedGroupsVeh;
		_activeGroupsVeh = aiMaster_activeGroupsVeh;
		_fightingGroupsVeh = aiMaster_fightingGroupsVeh;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_groups",aiMaster_groups - [ _x ] ]; deleteGroup _x; } } count _groups;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_cachedGroups",aiMaster_cachedGroups - [ _x ] ]; deleteGroup _x; } } count _cachedGroups;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_activeGroups",aiMaster_activeGroups - [ _x ] ]; deleteGroup _x; } } count _activeGroups;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_fightingGroups",aiMaster_fightingGroups - [ _x ] ]; deleteGroup _x; } } count _fightingGroups;
		if ( count _groups > 0 ) then { { _x call BRM_aiMaster_fnc_aiCache } count _groups; };
		if ( count _activeGroups > 0 ) then { aiMaster_patrolHouses = [ ]; { _x call BRM_aiMaster_fnc_patrols } count _activeGroups };
		if ( count _fightingGroups > 0 ) then { { _x call BRM_aiMaster_fnc_aiFight } count _fightingGroups };
		if ( count _activeGroups > 0 ) then { { _x call BRM_aiMaster_fnc_alert; _x call BRM_aiMaster_fnc_aiFight } count _activeGroups };
		//vehicle groups
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_groupsVeh",aiMaster_groupsVeh - [ _x ] ]; deleteGroup _x; } } count _groupsVeh;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_cachedGroupsVeh",aiMaster_cachedGroupsVeh - [ _x ] ]; deleteGroup _x; } } count _cachedGroupsVeh;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_activeGroupsVeh",aiMaster_activeGroupsVeh - [ _x ] ]; deleteGroup _x; } } count _activeGroupsVeh;
		{ if ( { alive _x }count units _x == 0 ) then { missionNamespace setVariable [ "aiMaster_fightingGroupsVeh",aiMaster_fightingGroupsVeh - [ _x ] ]; deleteGroup _x; } } count _fightingGroupsVeh;
		if ( count _groupsVeh > 0 ) then { { _x call BRM_aiMaster_fnc_aiCacheVeh; } count _groupsVeh; };
		if ( count _activeGroupsVeh > 0 ) then { { _x call BRM_aiMaster_fnc_patrolsVeh; _x call BRM_aiMaster_fnc_unFlip; } count _activeGroupsVeh };
		if ( count _fightingGroupsVeh > 0 ) then { { _x call BRM_aiMaster_fnc_aiFightVeh; _x call BRM_aiMaster_fnc_unFlip; } count _fightingGroupsVeh };
		if ( count _activeGroupsVeh > 0 ) then { { _x call BRM_aiMaster_fnc_alertVeh; _x call BRM_aiMaster_fnc_aiFightVeh } count _activeGroupsVeh };
		//cleanup	
		if (aiMasterLoopRun > 4) then {
			if ( count allDead > 15 ) then { call BRM_aiMaster_fnc_cleanUp }; aiMasterLoopRun = 0;
		} else {
			aiMasterLoopRun = aiMasterLoopRun + 1;
		};
	}, 3 ] call CBA_fnc_addPerFrameHandler;
};
