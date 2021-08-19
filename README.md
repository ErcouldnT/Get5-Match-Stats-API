# Get5 Match Stats API
**State:** *currently developing for first release*

## Feel free to Contribute & Roadmap:
1. Get the latest match stats with `native bool Get5_GetMatchStats(KeyValues kv);` on every
- `Get5_OnRoundStatsUpdated();`
- `Get5_OnSeriesResult(MatchTeam seriesWinner, int team1MapScore, int team2MapScore);`
- `Get5_OnDemoFinished(const char[] filename);`

2. Use [sm-json](https://github.com/clugg/sm-json) to change KeyValues to JSON

3. Send JSON body to a server via URL

4. First .smx release and testing

### CVARs
```
get5_match_stats_api_url - Set's the server url to send the post request to.
get5_match_stats_api_available - Checks if the plugin is correctly loaded on the server.
```

### Server Requirements

To use this plugin on your server, you must have the following:

- [Get5](https://github.com/splewis/get5)
- [SteamWorks](https://forums.alliedmods.net/showthread.php?t=229556)

### Build Requirements

To build the plugin, you must have the following:

- [Get5](https://github.com/splewis/get5) *forward and natives*
- [sm-json](https://github.com/clugg/sm-json) *for encoding JSON*
- [SteamWorks](https://raw.githubusercontent.com/KyleSanderson/SteamWorks/master/Pawn/includes/SteamWorks.inc) *for HTTP request*


#### Special Thanks to
- [splewis](https://github.com/splewis)
- [clugg](https://github.com/clugg)
> *all contributors*
