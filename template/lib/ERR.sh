#!/bin/env bash

ERR(){ >&2 echo "[WARNING]" "$*"; }
ERM(){ >&2 echo "[MESSAGE]" "$*"; }
ERX(){ >&2 echo "[ERROR]" "$*" && exit 1 ; }
