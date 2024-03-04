# `catalog.groovy`

Moves and renames JPEG files based on EXIF timestamp. 

Prerequisites:

* [Groovy](http://www.groovy-lang.org/)

Usage:
```
catalog.groovy [options]
```

Options:

* `-h`, `--help`
        
    Show usage description.

* `-s`, `--source`

    Source directory, defaults to `./unsorted`.    

* `-d`, `--destination`
        
    Destination root directory, defaults to `./images`. Stored file name pattern is `yyyy/MM/yyyyMMdd-HHmmss-[A..Z].jpg`.

* `-r`, `--recurse`

    Crawls source directory recursively, _disabled_ by default.

* `-k`, `--keep`

    Keeps original images in the source directory, _disabled_ by default.

* `-a`, `--auto`

    Enables automatic run with no user prompts, _disabled_ by default. 

* `-m`, `--modified`

    Uses file last modified timestamp if no EXIF metadata is found, _disabled_ by default.

* `-v`, `--verbose`
    
    Verbose output, _disabled_ by default.

Example:
```
catalog.groovy -s ./pictures/temp -d ./pictures/store
```