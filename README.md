# Get5-Match-Stats-API
**State:** *currently developing for first release*

## Feel free to Contribute & Roadmap:
1. Get the latest match stats with `native bool Get5_GetMatchStats(KeyValues kv);` on every
* `Get5_OnRoundStatsUpdated();`
* `Get5_OnSeriesResult(MatchTeam seriesWinner, int team1MapScore, int team2MapScore);`
* `Get5_OnDemoFinished(const char[] filename);`
* ~~`Get5_GetTeamScores(MatchTeam team, int& seriesScore, int& currentMapScore);`~~

2. Use [sm-json](https://github.com/clugg/sm-json) to change KeyValues to JSON

3. Send JSON body to a server url

4. First .smx release and testing

## Must be installed
* sm-json for encoding JSON
* SteamWorks for http request

## Special thanks to
* [splewis](https://github.com/splewis) ([get5](https://github.com/splewis/get5))
* [clugg](https://github.com/clugg) ([sm-json](https://github.com/clugg/sm-json))
* *all contributors*
