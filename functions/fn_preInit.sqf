asr_ai3_main_enabled = 0;
0 spawn {
	uiSleep 10;
	while {isNil "mission_AI_controller_name"} do {uiSleep 1;};
	if !(mission_ai_controller) exitWith { };
	aiMaster_groups = [ ];
	aiMaster_cachedGroups = [ ];
	aiMaster_activeGroups = [ ];
	aiMaster_fightingGroups = [ ];
	aiMaster_groupsVeh = [ ];
	aiMaster_cachedGroupsVeh = [ ];
	aiMaster_activeGroupsVeh = [ ];
	aiMaster_fightingGroupsVeh = [ ];
	call BRM_aiMaster_fnc_spawnUnits;
	uiSleep 10;
	aiMaster_debug = 0;
	aiMasterLoopRun = 0;
	aiMasterLoopNew = true;
	aiMasterLoop = [{
		if (aiMasterLoopNew) then {
			aiMasterLoopNew = false;
			aiMasterLoopCounter = 0;
			aiMaster_patrolHouses = [ ];
			{[_x,"aiMaster_groups"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_groups;
			{[_x,"aiMaster_cachedGroups"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_cachedGroups;
			{[_x,"aiMaster_activeGroups"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_activeGroups;
			{[_x,"aiMaster_fightingGroups"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_fightingGroups;
			aiMasterLoopGroups = aiMaster_groups;
			aiMasterLoopCachedGroups = aiMaster_cachedGroups;
			aiMasterLoopactiveGroups = aiMaster_activeGroups;
			aiMasterLoopfightingGroups = aiMaster_fightingGroups;
			{[_x,"aiMaster_groupsVeh"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_groupsVeh;
			{[_x,"aiMaster_cachedGroupsVeh"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_cachedGroupsVeh;
			{[_x,"aiMaster_activeGroupsVeh"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_activeGroupsVeh;
			{[_x,"aiMaster_fightingGroupsVeh"] call BRM_aiMaster_fnc_clearGroup}count aiMaster_fightingGroupsVeh;
			aiMasterLoopgroupsVeh = aiMaster_groupsVeh;
			aiMasterLoopcachedGroupsVeh = aiMaster_cachedGroupsVeh;
			aiMasterLoopactiveGroupsVeh = aiMaster_activeGroupsVeh;
			aiMasterLoopfightingGroupsVeh = aiMaster_fightingGroupsVeh;
		};
		private ["_loopgroup"];
		_loopgroup = nil;
		if (count aiMasterLoopGroups > 0) then {
			_loopgroup = aiMasterLoopGroups param [0];
			aiMasterLoopGroups = aiMasterLoopGroups - [_loopgroup];
		} else {
			if (count aiMasterLoopgroupsVeh > 0) then {
				_loopgroup = aiMasterLoopgroupsVeh param [0];
				aiMasterLoopgroupsVeh = aiMasterLoopgroupsVeh - [_loopgroup];
			};
		};
		if (isNil "_loopgroup") exitWith {aiMasterLoopNew = true;};
		if (_loopgroup in aiMaster_groups) then {_loopgroup call BRM_aiMaster_fnc_aiCache};
		if (_loopgroup in aiMaster_activeGroups) then {_loopgroup call BRM_aiMaster_fnc_patrols};
		if (_loopgroup in aiMaster_fightingGroups) then {_loopgroup call BRM_aiMaster_fnc_aiFight};
		if (_loopgroup in aiMaster_activeGroups) then {_loopgroup call BRM_aiMaster_fnc_alert;};
		if (_loopgroup in aiMaster_groupsVeh) then {_loopgroup call BRM_aiMaster_fnc_aiCacheVeh};
		if (_loopgroup in aiMaster_activeGroupsVeh) then {_loopgroup call BRM_aiMaster_fnc_patrolsVeh;_x call BRM_aiMaster_fnc_unFlip;};
		if (_loopgroup in aiMaster_fightingGroupsVeh) then {_loopgroup call BRM_aiMaster_fnc_aiFightVeh;_x call BRM_aiMaster_fnc_unFlip;};
		if (_loopgroup in aiMaster_activeGroupsVeh) then {_loopgroup call BRM_aiMaster_fnc_alertVeh;};
		if (aiMasterLoopRun > 100) then {
			if ( count allDead > 15 ) then {
				call BRM_aiMaster_fnc_cleanUp;};aiMasterLoopRun = 0;
		} else {
			aiMasterLoopRun = aiMasterLoopRun + 1;
		};
	}] call CBA_fnc_addPerFrameHandler;
};
