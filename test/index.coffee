#!/usr/bin/env coffee

import Lmdb from '../src/index'
import test from 'tape'

lmdb = Lmdb("/tmp/test/lmdb")
db = lmdb.db({
  encoding:'binary'
  compression:false
  keyIsUint32:true
})

test 'lmdb', (t)=>
  await lmdb => # 开启事务
    Promise.all [
      db.put(1,"1")
      db.put(77,"77")
      db.put(78,"78")
      db.put(79,"79")
    ]

  for i from db {start:1,end:78} # 迭代不包含end，输出 1，77
    console.log i
  console.log '---'
  for i from db {start:78,end:1,reverse:true} #反向迭代， 输出 78，77
    console.log i

  t.equal db.length , 4
  # t.deepEqual Xxx([1],[2]),[3]
  t.end()
