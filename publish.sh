#!/bin/bash

projectname=jwi
version_len=5
projectnameLen=${#projectname}

rm -rf target/scala-2.11/${projectname}_2.11-*
sbt publish

rm -rf target/scala-2.11/api
sbt doc


for f in target/scala-2.11/${projectname}_2.11-*
do
  echo $f
  nameOffset1=18+projectnameLen
  nameOffset2=5+$nameOffset1
  newname=${f:18:$projectnameLen}${f:${nameOffset2}}
  echo $newname
  len=24+$projectnameLen
  echo $len
  version=${f:$len:$version_len}
  echo $version
  dir=public_html/maven-repository/releases/att/${projectname}/$version
  echo $dir
  ssh k mkdir -p $dir
  echo 'scp' $f k:$dir
  scp $f k:$dir
  echo 'mv' $dir/${f:18} $dir/$newname
  ssh k "sed \"s/_2.11//g\" $dir/${f:18} > $dir/$newname"
  ssh k rm $dir/${f:18}
  
  rm -rf ~/.ivy2/cache/dhg/${projectname}/*-$version*
  rm -rf ~/.ivy2/cache/dhg/${projectname}/*/*-$version*

done

scp -r target/scala-2.11/api k:public_html/maven-repository/releases/att/${projectname}/$version

