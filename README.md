# Silent Sync

[![Build Status](https://api.travis-ci.org/ben-z/Silent-Sync.svg?branch=master)](https://travis-ci.org/ben-z/Silent-Sync)

Silent Sync is built for simplicity and clarity. With minimal setup, it automates the uploading process of working with a remote server.

*Warning: this plugin is not yet compatible with **windows**, please check back in a week or two as it's under ~~active development~~ (unfortunately no longer active due to the lack of time, please check out [atom-sync](https://atom.io/packages/atom-sync) instead.) :smile:. (Of course, any help is greatly appreciated!)*

## Installation

```bash
apm install silent-sync
```

## Features

* Run your project both locally and on a remote environment through automatic uploading.
* A nice little status bar widget<br />
<img src="https://raw.githubusercontent.com/ben-z/Silent-Sync/master/Statusbar.gif" width="300px"/>

## Settings

####Through atom's settings panel
* `Use configuration file`: Use `silent-sync.json` instead of the settings panel, recommended for individual projects. See documentation for more details.
* `Missing configuration file notification`: When `Use configuration file` is selected, notify if `silent-sync.json` is missing.
* `Enabled`: Only works when `Use configuration file` is off. Enable Silent Sync for your project.
* `Host`: The SSH host. eg. somedomain.com
* `Username`: The SSH username. eg. someone **Note:** authentication can only be done through an SSH key. [Here's a nice tutorial about it.](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
* `Remote Directory`: The absolute path of the remote server (without the backslash). eg. `/home/someone/Projects/myproject`.
* `Excluded files`: An `array` of excluded files, relative to project root. (with first backslash, separated by commas) eg. `/node_modules, /someDir, /someSubDir`.
* `Included files`: Included files (that are excluded above, eg. subdirectories/files of excluded), same format as the excluded.
* `Delete Remote Files`: Remove any remote files that aren't present locally.
* `Flags`: Custom flags for Rsync, defaults to 'avz'. A list of flags can be found [here](Options Summary).

####Using `silent-sync.json` (Recommended)
using a configuration file has the benefit of having a unique configuration for each project.

Enable `Use configuration file` in atom's settings panel and add a `silent-sync.json` to your project root.

example `silent-sync.json`
```json
{
  "enabled": true,
  "host": "somedomain.com",
  "port": 22,
  "username": "someone",
  "remoteDir": "/home/someone/Projects/myproject",
  "exclude": [
    "/someDir"
  ],
  "include": [
    "/someDir/something"
  ],
  "deleteRemoteFiles":true,
  "rsyncFlags": "avz"
}

```

After modifying the settings, restart the plugin by toggling it twice with `ctrl-alt-s` or using the menu to see the change take effect.

## Troubleshooting

Error | Possible Reasons
:---------:|:--------------
Code `255` | Cannot connect to server. 1. Server is down. 2. Key file does not match. 3. Host is not trusted (try to `ssh [YOUR_HOST]` in terminal and try again.)
Always displaying `SilentSync: Syncing` | Large projects can take a bit of time to sync. If it takes way too long, please create an issue with the steps to reproduce the problem.

Note: This is my first [atom.io](https://atom.io/) plugin, please feel free to send [pull requests](https://github.com/ben-z/Silent-Sync/pulls) or report [issues and bugs](https://github.com/ben-z/Silent-Sync/issues)!
