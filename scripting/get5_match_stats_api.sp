#include "include/get5.inc"
#include "include/logdebug.inc"
#include <cstrike>
#include <sourcemod>

#include "get5/util.sp"
#include "get5/version.sp"

#include <SteamWorks>
#include <json>  // github.com/clugg/sm-json

#include "get5/jsonhelpers.sp"

#pragma semicolon 1
#pragma newdecls required

ConVar g_EVENTAPIURLCvar;
char g_EVENTAPIURL[128];

// clang-format off
public Plugin myinfo = {
  name = "Get5 Match Stats API",
  author = "Ercode & splewis",
  description = "Sends the Get5 Match Stats to a server as JSON.",
  version = PLUGIN_VERSION,
  url = "https://github.com/ErcouldnT/Get5-Match-Stats-API"
};
// clang-format on

public void OnPluginStart() {
  InitDebugLog("get5_debug", "get5_api");
  LogDebug("OnPluginStart version=%s", PLUGIN_VERSION);

  g_EVENTAPIURLCvar = CreateConVar("get5_match_stats_api_url", "", "URL the get5 api is hosted at");

  HookConVarChange(g_EVENTAPIURLCvar, ApiInfoChanged);

  RegConsoleCmd("get5_match_stats_api_available", Command_Avaliable);
}

public Action Command_Avaliable(int client, int args) {
  char versionString[64] = "unknown";
  ConVar versionCvar = FindConVar("get5_version");
  if (versionCvar != null) {
    versionCvar.GetString(versionString, sizeof(versionString));
  }

  JSON_Object json = new JSON_Object();

  json.SetInt("gamestate", view_as<int>(Get5_GetGameState()));
  json.SetInt("available", 1);
  json.SetString("plugin_version", versionString);

  char buffer[256];
  json.Encode(buffer, sizeof(buffer), true);
  ReplyToCommand(client, buffer);

  delete json;

  return Plugin_Handled;
}

public void ApiInfoChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
  g_EVENTAPIURLCvar.GetString(g_EVENTAPIURL, sizeof(g_EVENTAPIURL));

  // Add a trailing backslash to the api url if one is missing.
  int len = strlen(g_EVENTAPIURL);
  if (len > 0 && g_EVENTAPIURL[len - 1] != '/') {
    StrCat(g_EVENTAPIURL, sizeof(g_EVENTAPIURL), "/");
  }

  LogDebug("get5_match_stats_api_url now set to %s", g_EVENTAPIURL);
}

static Handle CreateRequest(EHTTPMethod httpMethod, const char[] apiMethod, any:...) {
  char url[1024];
  Format(url, sizeof(url), "%s%s", g_EVENTAPIURL, apiMethod);

  char formattedUrl[1024];
  VFormat(formattedUrl, sizeof(formattedUrl), url, 3);

  LogDebug("Trying to create request to url %s", formattedUrl);

  Handle req = SteamWorks_CreateHTTPRequest(httpMethod, formattedUrl);
  if (req == INVALID_HANDLE) {
    LogError("Failed to create request to %s", formattedUrl);
    return INVALID_HANDLE;

  } else {
    SteamWorks_SetHTTPCallbacks(req, RequestCallback);
    return req;
  }
}

public int RequestCallback(Handle request, bool failure, bool requestSuccessful,
                    EHTTPStatusCode statusCode) {
  if (failure || !requestSuccessful) {
    LogError("API request failed, HTTP status code = %d", statusCode);
    char response[1024];
    SteamWorks_GetHTTPResponseBodyData(request, response, sizeof(response));
    LogError(response);
    return;
  }
}

static void AddJSONBody(Handle request, const char[] value) {
  if (!SteamWorks_SetHTTPRequestRawPostBody(request, "application/json", value, strlen(value))) {
    LogError("Failed to add http body %s", value);
  } else {
    LogDebug("Added body %s to request", value);
  }
}

// 1. Usable Forward and natives:

// Called when the stats for the last round have been updated.
// forward void Get5_OnRoundStatsUpdated();

// Called at the end of a full match.
// Note: both Get5_OnMapResult and Get5_OnSeriesResult are called on the last map of a series.
// forward void Get5_OnSeriesResult(MatchTeam seriesWinner, int team1MapScore, int team2MapScore);

// Called when a demo finishes recording.
// forward void Get5_OnDemoFinished(const char[] filename);

// Gets the scores for a match team.
// native void Get5_GetTeamScores(MatchTeam team, int& seriesScore, int& currentMapScore);

// Copies the current series stats into the passed KeyValues structure.
// Below are the keys used for stats in the kv copied.
// The caller is responsible for creating and deleting a KeyValues
// object if using this method.
// native bool Get5_GetMatchStats(KeyValues kv);

// 2. Use sm-json to change KeyValues to JSON

// 3. Send JSON body to a server url

// Example of sending JSON body to a url/stats:

// public void Get5_OnEvent(const char[] eventJson) {
//   Handle req = CreateRequest(k_EHTTPMethodPOST, "stats");
//   if (req != INVALID_HANDLE) {
//     AddJSONBody(req, eventJson);
//     SteamWorks_SendHTTPRequest(req);
//   }
// }
