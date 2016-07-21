# ghs

Sets GitHub [status](https://developer.github.com/v3/repos/statuses/) on a specified commit. Requires [Groovy](http://www.groovy-lang.org/) (e.g. via [SdkMan](http://sdkman.io/)).

Options:

* `-h`, `--help`
        
    Show usage description.

* `-d`, `--dry`
        
    Dry run, evaluates commit reference but does not set the status.

* `-r`, `--repo`

    Repository name including the owner (without `.git` extension).

* `-f`, `--ref`

    Commit reference as `type=id`, where `type` is `pull`, `branch` or `commit`. For `pull` the `id` is a pull request number and HEAD commit will be used. For `branch` the `id` is a branch name and HEAD commit will be used. For `commit` the `id` is either full SHA hash or shorter reference (first N digits).

* `-s`, `--status`

    Status to set in format `context=state`, where `context` is pre-arranged string and `state` is one of the following: `pending`, `success`, `error`, `failure`.


* `-t`, `--token`

    GitHub [access token](https://github.com/settings/tokens) to authenticate. The script will try to read from `~/.github-token` if this option is not used. The file should only contain the plain text token, e.g.:
    ```
    b989c210ab6ba09365crtd8bwq2c938a553e003
    ```

* `-c`, `--comment`
    
    Comment to add, double-quoted. Supported for _pull request_ reference only.

Example:
```
ghs -r owner/repo -f pull=33 -s code-review=success -c ":+1: LGTM"
```


