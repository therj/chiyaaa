# Chiyaaa

## Welcome to Chiyaaa Shell

Track all you drink - straight from the terminal. Sync the data to git repo or your own server. **Built with bash.**

## Setting up:

1. Fork the the repository to your account.
2. Clone it to your device.

```bash
git clone https://github.com/<your-username>/tea-counter-shell
```

Rename `env.sample.sh` to `env.sh`

```bash
cp env.sample.sh env.sh
```

**Each variable in env.sh acts as a setting in itself**

## General Settings

**minRepeatInMinutes:** Will ask for confirmation if you make a new entry within this many minutes of last one.

**currentYear:** 2021. Used to make count. The count returned is for the current year. The same count is written to index.html

**drinkName:** Why only `tea`? Drink anything. Used as a git commit message.

**unitName:** `cup` of tea or `glass` of wine, the code doesn't care.

## Flags

All flags are enabled with 1 and disabled with any other value.

Git is required for git-based flags.

**gitCommit:** Program will make a commit with `nth cup of tea in 2020`. `tea` and `cup` replaced with _drinkName_ and _unitName_ respectively. Disabling commit will also disable push operation

**gitPush:** Program will push to the configured remote repository. Remote repository must be set beforehand.

**rsyncToRemote:** Program will sync `index.html` file to your remote server using rsync. Not recommended if you don't have experience with servers and ssh.

## rsync settings

***Make sure you can access server with ssh.***

Required only if **rsyncToRemote** is enabled.

**remoteUser:** ssh username on the server

**remoteIp:** IP address to ssh into.

**remotePath:** The index file is synced via `rsync` to your server to at this provided path.

## How to use

### Update the count

Execute the `drink.sh` file every time. Or set up an alias in `.bashrc` (or `.zshrc`, or whatever applies for you).

```bash
drink(){
  /path/to/file/tea/drink.sh $@
}
```

_\$@ is required to pass the flags from the terminal. More on that later_

If you cloned to your home directory, add the following to your `.bashrc`.

```bash
drink(){
  $HOME/tea-counter-shell/drink.sh $@
}
```

After setting the alias, you can run as following:

```
drink
# current datetime is appended to history file
# index file is overwritten with updated count
```

### Passing flags

If you want to increase the count but don't want to push, commit or rsync, you can disable the flags in `env.sh`. Those will act as global settings. You can push the changes at a later time (manually or with `drink --nocount`) or just keep them locally.

If you need to disable some or all of those settings for the new entry you're making, you can pass flags with the command.

_These flags do not affect updating the history and index file._

**Example Command with flags:**

```bash
drink --no # no git commit, no push, no rsync. Just update history and index
```

```bash
drink --nocommit # no git commit, no commit also implies nothing to push
```

```bash
drink --nopush # commit and rsync, but no push
```

```bash
drink --norsync # commit & push, but no  rsync
```

```bash
drink --nocount # doesn't increment the count, use this to sync past changes without a new entry
```

**Flags can be mixed**

```bash
drink --norsync --nopush # commit, but no rsync or push
```

## Files

- history.txt => all entries are saved here

- env.sh => associated variables. Added to gitignore, by default as it may contain ssh username and ip for rsync.

- env.sample.sh => sample env.sh

- index.html => count is here. It is overwritten on every run!

- drink.sh => Main executable file

- init.sh => initialization script [[Coming Soon]]

## Use case

### GitHub

Index file is committed and pushed. [View the file in repo](https://github.com/therj/tea-counter-shell/blob/master/index.html) or [view as raw](https://github.com/therj/tea-counter-shell/blob/master/index.html?raw=true)

~~Count accessed here could be used as a content anywhere. For example, I use in the footer of my [blog](https://rjoshi.net).~~

### Rsync

~~Index file uploaded to (with rsync): [rjoshi.com.np/tea](https://rjoshi.com.np/tea/)~~

~~Above url is fetched at: [rjoshi.net](https://rjoshi.net) - [in the footer]~~

_All counts should be same. Any inconsistency is due to caching, or disabled flags (rarely)._
