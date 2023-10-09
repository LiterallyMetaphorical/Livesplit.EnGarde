/*
Legend:
MM == Main Menu
E1M1 == Episode 1 Map 1
E1C1 == Episode 1 Cutscene 1

Map IDs:

MM   ``/Game/EnGarde/Maps/MainMenu/MainMenu``
//note that v1.4+ for some reason you cant scan main menu first lol. Load into E1M1 and start scan from there, then go to MM.
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
    string300 activeSubtitle : 0x0758C610, 0x0, 0x10, 0x3D0, 0x20, 0x28, 0x0;
}

state ("EnGarde-Win64-Shipping", "Steam v1.3") 
{
    string300 activeSubtitle : 0x07590AC8, 0x2C0, 0xD8, 0x6E8, 0x28, 0x0; // 28 and 0 are consistent offsets
}

state ("EnGarde-Win64-Shipping", "Steam v1.4") 
{
    string300 activeSubtitle : 0x07590AC8, 0x2C0, 0xD8, 0x6E8, 0x28, 0x0; // 28 and 0 are consistent offsets
}

init
{
    // Scanning the MainModule for static pointers to GSyncLoadCount, UWorld, UEngine and FNamePool
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var syncLoadTrg = new SigScanTarget(5, "89 43 60 8B 05 ?? ?? ?? ??") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) };
    var syncLoadCounterPtr = scn.Scan(syncLoadTrg);

    //sig scan for loaded map lol idk what else to write here
    var loadedMapBaseAddress = scn.Scan(new SigScanTarget(3, "488B??????????498B??E8????????488B??????????41BF") { OnFound = (p, s, ptr) => ptr + 0x4 + game.ReadValue<int>(ptr) });
    var loadedMapPointer = new DeepPointer (loadedMapBaseAddress, 0xAE0, 0x0);
    

    vars.Watchers = new MemoryWatcherList
    {
        // GSyncLoadCount
        new MemoryWatcher<int>(new DeepPointer(syncLoadCounterPtr)) { Name = "syncLoadCount" },
        new StringWatcher(loadedMapPointer,150) { Name = "loadedMap"}
    };

    vars.doneMaps = new List<string>();

    vars.Watchers.UpdateAll(game);

    //helps to fix errors for old states of the sigscan
    current.loadedMap = "";

    //sets var loading from the memory watcher
    current.loading = old.loading = vars.Watchers["syncLoadCount"].Current > 0;

    switch (modules.First().ModuleMemorySize) 
    {
        case 130756608: 
            version = "Steam v1.1";
            break;
        case 130764800 : 
            version = "Steam v1.3";
            break;
        case 127627264 :
            version = "Steam v1.4";
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

    //creates text components for variable information
	vars.SetTextComponent = (Action<string, string>)((id, text) =>
	{
	        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
	        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
	        if (textSetting == null)
	        {
	        var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
	        var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
	        timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));
	
	        textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
	        textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
	        }
	
	        if (textSetting != null)
	        textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    });
}

update
{ 
    vars.Watchers.UpdateAll(game);

    // The game is considered to be loading if any scenes are loading synchronously
    current.loading = vars.Watchers["syncLoadCount"].Current > 0;
    current.loadedMap = vars.Watchers["loadedMap"].Current;
    //print(current.loading.ToString());
    print(current.loadedMap.ToString());
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
	return current.loading ||
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
    vars.doneMaps.Clear();
}
