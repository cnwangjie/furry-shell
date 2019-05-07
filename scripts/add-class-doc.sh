#!/bin/bash

if [ ! -e ".git" ]; then
  echo "not exists git repository (`pwd`)"
  exit 0
fi
git ls-files | grep -E ".java$" | while read FILE; do
  printf "$FILE "
  CREATE_TIMESTAMP=`git log --all --format="%ct" "$FILE" | tail -n 1`
  CREATE_DATE=`date +%D --date="@$CREATE_TIMESTAMP"`
  CLASS_LINE=`grep -E "public +(class)|(interface)" -n "$FILE" | grep -E "[0-9]+" -o | head -n 1`
  FIRST_NOT_ANNOTATION_LINE=`head -n "$CLASS_LINE" "$FILE" | grep -v -n -E "." | tail -n 1 | grep -E "[0-9]+" -o | head -n 1`
  ADD_LINE=$FIRST_NOT_ANNOTATION_LINE
  AUTHORS=`git log --all --format="%an <%ae>" "$FILE" | nl | sort -k2,2 -k1,1n | uniq -f1 | sort -k1,1n | cut -f2- | tac`
  AUTHORS_TEMP=`echo "$AUTHORS" | sed "s/^/ * @author /"`
  TITLE=`basename "$FILE"`
  PACKAGE=`sed -r "s/package ([a-z\.]+);/\1/;q" "$FILE"`
  JAVADOC_TEMP="/**
 * <p>Title: $TITLE</p>
 * <p>Package: $PACKAGE</p>
 * <p>Description: </p>
 * <p>Copyright: 2018 the original author or authors.</p>

 * @date $CREATE_DATE
$AUTHORS_TEMP
 */"
  echo "$JAVADOC_TEMP" > /tmp/add-class-doc-temp
  ADD_LINE_CONTENT=`head "$FILE" -n "$ADD_LINE" | tail -n 1`
  if [ "$ADD_LINE_CONTENT" = " */" ]; then
    echo -e "\033[33m existed \033[0m"
    continue
  fi
  sed -i "${ADD_LINE}r /tmp/add-class-doc-temp" "$FILE"
  echo -e "\033[32m done! \033[0m"
done
