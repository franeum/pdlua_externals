#!/usr/bin/env lua5.4

local sqlite3 = require('lsqlite3complete')
local filename = 'dbtest.db'
local db = sqlite3.open(filename)

db:exec("CREATE TABLE test(col1,col2,col3)")
db:exec('INSERT INTO test VALUES(1,2,4)')
db:exec('INSERT INTO test VALUES(2,4,9)')
db:exec('INSERT INTO test VALUES(3,6,16)')

db:close()