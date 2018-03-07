#!/bin/bash

PROG_DIR="$(cd $(dirname "$0"); pwd)"
PROG_NAME="$(basename "$0")"

usage() {
    echo "Usage: $PROG_NAME [OPTIONS] apkPath newPackageName"
    echo "  This utility changes APK's package name in AndroidManifest.xml:"
    echo ""
    echo "Examples:"
    echo " $PROG_NAME /tmp/old.apk com.exampe.newapp "
    exit 1
}

if [ "$#" -ne 2 ]; then echo "too few arguments"; usage; fi

apkPath=$1
newPackageName=$2
echo "~~~~ use newPackageName: $newPackageName"

if [ ! -f "$apkPath" ]; then echo "file does not exist: $apkPath"; exit 1; fi

packageName=""
workDir="`dirname "$apkPath"`/tmpForApkRename"
apkName="`basename "$apkPath"`"

echo "~~~~ prepare work dir: $workDir"
rm -rf "$workDir"
mkdir -p "$workDir" || exit 1
mkdir "$workDir/update" | exit 1

#------------------------------------------------------------------------------------------------
cd "$workDir" || exit 1

needUpdate=0

echo ""
echo "~~~~ extract AndroidManifest.xml (binary file)"
jar xvf "../$apkName" AndroidManifest.xml || exit 1

echo ""
echo "~~~~ change package name of AndroidManifest.xml"
java -jar "$PROG_DIR/lib/AndroidManifestBinaryXml_ChangePackageName/bin/setAxmlPkgName.jar" AndroidManifest.xml "$newPackageName"
rc=$?
if [ $rc == 0 ]; then
    cp AndroidManifest.xml update/
    needUpdate=1
elif [ $rc == 2 ]; then
    echo "~~~~ need not change AndroidManifest.xml"
else
    exit 1
fi

echo ""
if [ $needUpdate == 1 ]; then
    echo "~~~~ update apk"
    jar uvf "../$apkName" -C update/ . || exit 1
else
    echo "~~~~ need not update apk"
fi

echo ""
echo "OK. Result file is: $apkPath"