# Get5-Match-Stats-API
State: "currently developing for first release"

## Feel free to Contribute & Todo:
1. Forward and natives
* Get5_OnRoundStatsUpdated();
* Get5_OnSeriesResult(MatchTeam seriesWinner, int team1MapScore, int team2MapScore);
* Get5_OnDemoFinished(const char[] filename);
* Get5_GetTeamScores(MatchTeam team, int& seriesScore, int& currentMapScore);
* And of course: native bool Get5_GetMatchStats(KeyValues kv);

2. Use sm-json to change KeyValues to JSON

3. Send JSON body to a server url

## Special thanks to
* splewis (get5)
* clugg (sm-json)
* other contributors
