//POSTINIT
//
//
while {isNil "mission_AI_controller_name"} do {uiSleep 1;};
//if !(mission_ai_controller) exitWith { };
//[[*spawn logic*,*patrol logic*],*spawn distance*,*patrol distance*,[*side*,*unitArray*],[*patrol buildings*,*stance*,*speed*],*outer spawn*,[*min*,*max*],*offencive*,*skill*,[*startCached*,*limit*,*disabled*],*wave_var*] call BRM_aiMaster_fnc_aiSpawnInf;
//[[*spawn logic*,*patrol logic*],*spawn distance*,*patrol distance*,[*side*,*unitArray*],[*only roads*,*stance*,*speed*,*trans*],*outer spawn*,*road spawn*,[*min*,*max*],*offencive*,*skill*,[*startCached*,*limit*,*disabled*],*wave_var*] call BRM_aiMaster_fnc_aiSpawnVeh;
//town1
[town1,150,150,[west,3],[true,"SAFE","LIMITED"],false,[4,4],false,0.8,[false,45]] call BRM_aiMaster_fnc_aiSpawnInf;
[town1,200,200,[west,3],[false,"SAFE","LIMITED"],false,[2,2],true,0.8,[false,45]] call BRM_aiMaster_fnc_aiSpawnInf;
[town1,100,200,[west,6],[true,"SAFE","LIMITED",false],false,true,[1,1],true,0.8,[false,45]] call BRM_aiMaster_fnc_aiSpawnVeh;
[[back1,town1],100,150,[west,5],[true,"AWARE","FULL",false],false,true,[1,2],true,0.8,[true,50],"task1_wave"] call BRM_aiMaster_fnc_aiSpawnVeh;
[[back1,town1],100,150,[west,4],[true,"AWARE","FULL",false],false,true,[1,1],true,0.8,[true,50],"task1_wave"] call BRM_aiMaster_fnc_aiSpawnVeh;
[[back1,town1],100,150,[west,3],[true,"AWARE","FULL",false],false,true,[1,1],true,0.8,[true,50],"task1_wave"] call BRM_aiMaster_fnc_aiSpawnVeh;
