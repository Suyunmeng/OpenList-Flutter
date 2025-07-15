#!/bin/bash

mkdir /tmp/openlist
rm -rf /tmp/openlist/*
cp -r ../scripts /tmp/openlist
cp -r ../openlistlib /tmp/openlist

rm -rf ../*

cp -r /tmp/openlist/* ../