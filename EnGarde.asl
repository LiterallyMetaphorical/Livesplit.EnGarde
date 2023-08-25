/*
Legend:
MM == Main Menu
E1M1 == Episode 1 Map 1
E1C1 == Episode 1 Cutscene 1

Map IDs:

MM   ``/Game/EnGarde/Maps/MainMenu/MainMenu``

E1C1 ``/Game/EnGarde/Maps/Main_Level1/L1_DioramaBegin/LB_DB_Persistent``
E1M1 ``/Game/EnGarde/Maps/Main_Level1/L1_C1/LBC1_Persistent``
E1M2 ``/Game/EnGarde/Maps/Main_Level1/L1_A6/LBA6_Persistent``
E1M3 ``/Game/EnGarde/Maps/Main_Level1/L1_C2/LBC2_Persistent``
E1M4 ``/Game/EnGarde/Maps/Main_Level1/L1_A1/LBA1_Persistent``
E1M5 ``/Game/EnGarde/Maps/Main_Level1/L1_A2/LBA2_Persistent``
E1M6 ``/Game/EnGarde/Maps/Main_Level1/L1_A3/LBA3_Persistent``
E1M7 ``/Game/EnGarde/Maps/Main_Level1/L1_A4/LBA4_Persistent``
E1C2 ``/Game/EnGarde/Maps/Main_Level1/L1_DioramaEnd/LB_DE_Persistent``

E2C1 ``/Game/EnGarde/Maps/Main_Level2/L2DioramaBegin/LADB_Persistent``
E2M1 ``/Game/EnGarde/Maps/Main_Level2/L2C1/LAC1_Persistent``
E2M2 ``/Game/EnGarde/Maps/Main_Level2/L2A1/LAA1_Persistent``
*/

state ("EnGarde-Win64-Shipping", "Steam v1.1") 
{
	int loading              : 0x075AB490, 0x0, 0x100, 0xBF0;
    string300 activeSubtitle : 0x0758C610, 0x0, 0x10, 0x3D0, 0x20, 0x28, 0x0;
    string150 loadedMap      : 0x0758AC40, 0xAE0, 0x0;
}

state ("EnGarde-Win64-Shipping", "Steam v1.3") 
{
	int loading              : 0x072955B0, 0x8, 0x3BC;
    string300 activeSubtitle : 0x07590AC8, 0x2C0, 0xD8, 0x6E8, 0x28, 0x0; // 28 and 0 are consistent offsets
    string300 loadedMap      : 0x0758CCC0, 0xAE0, 0x0;
}

init
{
    vars.doneMaps = new List<string>();

    switch (modules.First().ModuleMemorySize) 
    {
        case 130756608: 
            version = "Steam v1.1";
            break;
        case 130764800 : 
            version = "Steam v1.3";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
}

onStart
{
    // This is a "cycle fix", makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
    vars.doneMaps.Add(current.loadedMap);
}

startup
  {
    settings.Add("EnGarde", true, "All Maps");
    settings.Add("E3M1 Exhibition Room", false, "Split when Adalia reaches the exhibition room with Zaida in E3M1");
    settings.Add("Count-Duke Defeated", false, "Split when Adalia says I have you now, Count-Duke! near the end of E4M8");

    vars.Maps = new Dictionary<string,string> 
	{
    // Chapter 1
      //{"/Game/EnGarde/Maps/Main_Level1/L1_C1/LBC1_Persistent", "E1M1"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_A6/LBA6_Persistent", "E1M2"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_C2/LBC2_Persistent", "E1M3"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_A1/LBA1_Persistent", "E1M4"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_A2/LBA2_Persistent", "E1M5"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_A3/LBA3_Persistent", "E1M6"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_A4/LBA4_Persistent", "E1M7"},
        {"/Game/EnGarde/Maps/Main_Level1/L1_DioramaEnd/LB_DE_Persistent", "E1 Ending Cutscene"},
    // Chapter 2
      //{"/Game/EnGarde/Maps/Main_Level1/L1_A4/LBA4_Persistent", "E2M1"},
        {"/Game/EnGarde/Maps/Main_Level2/L2A1/LAA1_Persistent", "E2M2"},
        {"/Game/EnGarde/Maps/Main_Level2/L2C2/LAC2_Persistent", "E2M3"},
        {"/Game/EnGarde/Maps/Main_Level2/L2A2/LAA2_Persistent", "E2M4"},
        {"/Game/EnGarde/Maps/Main_Level2/L2C3/LAC3_Persistent", "E2M5"},
        {"/Game/EnGarde/Maps/Main_Level2/L2A3/LAA3_Persistent", "E2M6"},
        {"/Game/EnGarde/Maps/Main_Level2/L2C4/LAC4_Persistent", "E2M7"},
        {"/Game/EnGarde/Maps/Main_Level2/L2A4/LAA4_Persistent", "E2M8"},
        {"/Game/EnGarde/Maps/Main_Level2/L2DioramaEnd/LADE_Persistent", "E2 Ending Cutscene"},
    // Chapter 3
      //{"/Game/EnGarde/Maps/Main_Level2/L2A4/LAA4_Persistent", "E3M1"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCA1/LCA1_Persistent", "E3M2"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCC2/LCC2_Persistent", "E3M3"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCA2/LCA2_Persistent", "E3M4"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCC3/LCC3_Persistent", "E3M5"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCA3/LCA3_Persistent", "E3M6"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCC4/LCC4_Persistent", "E3M7"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCA4/LCA4_Persistent", "E3M8"},
        {"/Game/EnGarde/Maps/Main_LevelC/LCDioramaEnd/LCDE_Persistent", "E3 Ending Cutscene"},
    // Chapter 4
        //{"/Game/EnGarde/Maps/Main_LevelD/LDC1/LDC1_Persistent", "E4M1"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDC2-1/LDC2-1_Persistent", "E4M2"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDA1/LDA1_Persistent", "E4M3"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDC2-2/LDC2-2_Persistent", "E4M4"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDA2/LDA2_Persistent", "E4M5"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDC2-3/LDC2-3_Persistent", "E4M6"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDC2-4/LDC2-4_Persistent", "E4M7"},
        {"/Game/EnGarde/Maps/Main_LevelD/LDA4/LDA4_Persistent", "E4M8"},
        {"/Game/EnGarde/Maps/Main_LevelD/LD_DioramaEnd/LDDE_Persistent", "E4 Ending Cutscene"},
    };
    foreach (var Tag in vars.Maps)
		{
			settings.Add(Tag.Key, true, Tag.Value, "EnGarde");
    	};


		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | En Garde!",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

update
{ 
    print(current.loading.ToString());
    //print(current.loadedMap.ToString());
    //print(current.activeSubtitle.ToString());
    //print(modules.First().ModuleMemorySize.ToString());
}

start
{
if
    (   //Episode 1 Autostart
        (old.loadedMap == "/Game/EnGarde/Maps/Main_Level1/L1_DioramaBegin/LB_DB_Persistent" && current.loadedMap == "/Game/EnGarde/Maps/Main_Level1/L1_C1/LBC1_Persistent") ||
        //Episode 2 Autostart
        (old.loadedMap == "/Game/EnGarde/Maps/Main_Level2/L2DioramaBegin/LADB_Persistent"   && current.loadedMap == "/Game/EnGarde/Maps/Main_Level2/L2C1/LAC1_Persistent") ||
        //Episode 3 Autostart
        (old.loadedMap == "/Game/EnGarde/Maps/Main_LevelC/LCDioramaBegin/LCDB_Persistent"   && current.loadedMap == "/Game/EnGarde/Maps/Main_LevelC/LCC1/LCC1_Persistent") ||
        //Episode 4 Autostart
        (old.loadedMap == "/Game/EnGarde/Maps/Main_LevelD/LD_DioramaBegin/LDDB_Persistent"   && current.loadedMap == "/Game/EnGarde/Maps/Main_LevelD/LDC1/LDC1_Persistent")
    )  
        return true;
}

split
{
    if (settings[current.loadedMap] && (!vars.doneMaps.Contains(current.loadedMap)))
    {
        vars.doneMaps.Add(current.loadedMap);
        return true;
    }

    if (settings["E3M1 Exhibition Room"] && current.activeSubtitle == "Speak with Zaida" && old.activeSubtitle != "Speak with Zaida")
    {
        return true;
    }
        if (settings["Count-Duke Defeated"] && current.activeSubtitle == "I have you now, Count-Duke!" && old.activeSubtitle != "I have you now, Count-Duke!")
    {
        return true;
    }
}

isLoading 
{   //regular loads
	return current.loading == 1 ||
    //End Screen Episode 1
    current.loadedMap == "/Game/EnGarde/Maps/Main_Level1/L1_DioramaEnd/LB_DE_Persistent" ||
    //End Screen Episode 2
    current.loadedMap == "/Game/EnGarde/Maps/Main_Level2/L2DioramaEnd/LADE_Persistent" ||
    //End Screen Episode 3
    current.loadedMap == "/Game/EnGarde/Maps/Main_LevelC/LCDioramaEnd/LCDE_Persistent" ||
    //End Screen Episode 4
    current.loadedMap == "/Game/EnGarde/Maps/Main_LevelD/LD_DioramaEnd/LDDE_Persistent";
}

onReset
{
    vars.doneMapss.Clear();
}
