# Tea Counter Shell


## Setting up
Rename `env.sample.sh` to `env.sh`
```bash
  cp env.sample.sh env.sh
```

The count file is synced via `rsync` to your server to at the provided path. Some experience with ssh and servers is expected!

## Variables

**remoteUser:** Your server's ssh username

**remoteIp:** Server's IP or hostname

**remotePath:** Path on the remote system

**pushToRemote:** Enable/disable rsync. 1 to enable

## Update the count

Execute the `drink.sh` file.

Or set up an alias in  `.bashrc`, `.zshrc`, etc.

```bash
drink(){
  /path/to/file/tea/drink.sh
}
```

Example:
If you cloned to your home directory
```bash
drink(){
  $HOME/tea-counter-shell/tea/drink.sh
}
```


## Files

- history.txt => all entries are saved here

- env.sh => associated variables (keep it private!)

- env.sample.sh => sample env.sh

- index.html => count is here. It is overwritten on every run!

- drink.sh => Main executable file

- init.sh => initialization script (TODO)
