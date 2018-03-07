#!/bin/bash

if (( $# < 2 )); then echo "need parameters: apkPath debugKeyStoreFile"; exit 1; fi
apkPath="$1"
if [ ! -f "$apkPath" ]; then echo "file does not exist: $apkPath"; exit 1; fi
debugKeyStoreFile="$2"
if [ ! -f "$debugKeyStoreFile" ]; then echo "file does not exist: $debugKeyStoreFile"; exit 1; fi

echo ""
echo "~~~~ add signature"
jarsigner -keystore "$debugKeyStoreFile" -sigfile CERT -sigalg SHA1withRSA -digestalg SHA1 -storepass aristo@123 -keypass aristo@123 "$apkPath" app || exit 1
echo "OK"
