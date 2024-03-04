# `ghs.groovy`

Sets GitHub [status](https://developer.github.com/v3/repos/statuses/) on a specified commit. 

Prerequisites:

* [Groovy](http://www.groovy-lang.org/)
* GitHub API [access token](https://github.com/settings/tokens) in `~/.github-token` (optional)

Usage:
```
ghs.groovy [options]
```

Options:

* `-h`, `--help`
        
    Show usage description.

* `-d`, `--dry`
        
    Dry run, evaluates commit reference but does not set the status.

* `-r`, `--repo`

    Repository name including the owner (without `.git` extension).

* `-f`, `--ref`

    Commit reference as `type=id`, where `type` is one the following:
    
    * `pull`: the `id` is a pull request number and HEAD commit will be used
    * `branch`: the `id` is a branch name and HEAD commit will be used
    * `commit`: the `id` is commit hash or shorter reference (first N digits)

* `-s`, `--status`

    Status to set in format `context=state`, where `context` is pre-arranged string and `state` is one of the following: 
    
    * `pending`
    * `success`
    * `error`
    * `failure`

* `-t`, `--token`

    GitHub access token to authenticate. The script will try to read from `~/.github-token` if this option is not used. The file should only contain the _plain text_ token.

* `-c`, `--comment`
    
    Comment to add, double-quoted. Supported for `pull` reference only.

Example:
```
ghs.groovy -r owner/repo -f pull=33 -s code-review=success -c ":+1: LGTM"
```
