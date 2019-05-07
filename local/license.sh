#!/bin/bash

# license.sh
# generate license easily
# author: Wang Jie <i@i8e.net>
# site: www.cnwangjie.com
# date: 2017-04-15
clear
echo "license: (empty to list all licenses)"
read license
if [ -z "$license" ]; then
    clear
    echo requesting...
    list=$(curl -H 'Accept:application/vnd.github.drax-preview+json' https://api.github.com/licenses | grep -Po '^.*key.*$' | sed 's/ *"key": *"//g; s/", *//g')
    clear
    echo support licenses:
    echo
    echo ${list} | sed 's/ /\n/g' | cat -n
    exit 0
fi

clear
echo requesting...
json=$(curl -H 'Accept:application/vnd.github.drax-preview+json' https://api.github.com/licenses/${license} | grep -Po '^.*body.*$')

if [ -z "$json" ]; then
    clear
    echo license is unsupported
    exit 0
fi

echo ${json} | sed 's/"body": "//; s/"$//; s/\\n/\n/g' > LICENSE
echo 'LICENSE file has been generated!'

if [ "$license" = "epl-1.0" ]; then
    exit 0
elif [ "$license" = "lgpl-3.0" ]; then
    exit 0
elif [ "$license" = "mpl-2.0" ]; then
    exit 0
elif [ "$license" = "unlicense" ]; then
    exit 0
fi


echo "we can replace the year and name of license for you, if "
echo "you don't need it you can interrupt it now, or enter the"
echo "beginning year of the copyright here:"
read year
echo "now enter the name of copyright here:"
read name
curyear=$(date +%Y)
if [ "$year" != "$curyear" ]; then
    year=${year}"-"${curyear}
fi

if [ "$license" = "agpl-3.0" ]; then
    echo "enter the program's name here:"
    read project
    sed -i "s/<one line to give the program's name and a brief idea of what it does.>/${project}/" LICENSE
    sed -i "s/<year>/${year}/" LICENSE
    sed -i "s/<name of author>/${name}/" LICENSE
elif [ "$license" = "apache-2.0" ]; then
    sed -i "s/{yyyy}/${year}/" LICENSE
    sed -i "s/{name of copyright owner}/${name}/" LICENSE
elif [ "$license" = "bsd-2-clause" ]; then
    sed -i "s/\[year\]/${year}/" LICENSE
    sed -i "s/\[fullname\]/${name}/" LICENSE
elif [ "$license" = "bsd-3-clause" ]; then
    sed -i "s/\[year\]/${year}/" LICENSE
    sed -i "s/\[fullname\]/${name}/" LICENSE
elif [ "$license" = "gpl-3.0" ]; then
    echo "enter the program's name here:"
    read project
    sed -i "s/{one line to give the program's name and a brief idea of what it does.}/${project}/" LICENSE
    sed -i "s/{year}/${year}/" LICENSE
    sed -i "s/{name of author}/${name}/" LICENSE
elif [ "$license" = "lgpl-2.1" ]; then
    echo "enter the program's name here:"
    read project
    sed -i "s/{description}/${project}/" LICENSE
    sed -i "s/{year}/${year}/" LICENSE
    sed -i "s/{fullname}/${name}/" LICENSE
elif [ "$license" = "mit" ]; then
    sed -i "s/\[year\]/${year}/" LICENSE
    sed -i "s/\[fullname\]/${name}/" LICENSE
fi
echo 'done!'
exit 0
