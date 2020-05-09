#!/bin/bash -ex

. ./env

qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel ${TARGET_DIR}/test.bin
