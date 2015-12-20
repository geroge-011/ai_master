class BRM_aiMaster
{
	class fnc {
		file = "framework\plugins\ai_suite\functions\fnc";
		class landPos{};
		class roadPos{};
		class buildingPos{};
		class unFlip{};
	};
	class ai_fnc {
		file = "framework\plugins\ai_suite\functions\ai";
		class aiCache{};
		class aiCacheVeh{};
		class aiFight{};
		class aiFightVeh{};
		class aiSpawnInf{};
		class aiSpawnVeh{};
		class alert{};
		class alertVeh{};
		class buildingPatrols{};
		class cleanUp{};
		class patrols{};
		class patrolsVeh{};
	};
	class init {
		file = "framework\plugins\ai_suite\functions";
		class preInit {preInit = 1;};
		class spawnUnits {};
	};
}; 
