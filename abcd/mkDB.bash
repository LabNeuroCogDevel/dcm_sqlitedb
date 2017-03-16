#!/usr/bin/env bash

[ -r db.sqlite3 ] && rm db.sqlite3
sqlite3 db.sqlite3 < <(cat schema.sql import.sql mkvisit.sql mksubj.sql)

