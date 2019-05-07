furry-shell
======

Useful shell script for myself.

### Descriptions

|directory|description|
|---|---|
|local|things frequently used, usually be set as env PATH|
|server|I use them in my server, usually set to a cron task|
|scripts|some things be used in sometimes or only once for a complex task|

<details>
<summary>script descriptions</summary>

|script name|description|
|---|---|
|lamp.sh|set up Apache + Mysql + PHP enviroment suitable for Debian and CentOS|
|node.sh|set up Node.js + Mongodb + Redis enviroment suitable for any release version|
|npmrc.sh|switch repositry of NPM between offical and taobao|
|license.sh|easy to create a license based on Github API|
|upic.sh|upload lastest screenshot|
|bootrun.sh| |
|help.sh|notice forgetful me|
|list-git-status.sh|list git status of child directory of current directory|
|zhinput|type chinese in Minecraft|
|byzanz-record-gui.sh|use byzanz to record a gif|
|try.sh|auto open a file in temp directory for try|
|add-class-doc.sh|add class level javadoc for all java source code of current git repo|
|toggle-display.sh|toggle second display status|
|backlight.sh|set backlight of laptop keyboard|
|scr.sh|take screenshot|

</details>

### Usage

Clone this repo and add this directory to $PATH then you can use them anywhere.

Even you can set a keyborad shortcut for some of them.

Or use `curl -L FILE_RAW_LINK | bash -s ARGS` to execute directly

### Notes

It is highly recommended **to run your application in Docker or other container environment** instead of to setup the host enviroment by a shell script.

### License

**MIT License for all I code it**

Follow the original license referenced (kept them in code comment)
