#!/usr/bin/env coffee

import Lmdb from '@rmw/lmdb'
import test from 'tape-catch'

test 'lmdb',(t)=>

  lmdb = Lmdb("/tmp/test/lmdb")
  db = lmdb.just_test( # just_test 是数据库名，可以随便定义
    {
      encoding:'binary'
      compression:false
      keyIsUint32:true
    }
  )

  print = =>
    console.log "\n---\n"
    for i from db {start:1}
      console.log i
    console.log "db.length", db.length

  await lmdb => # 开启事务
    todo = []
    for i in [1,2,77,78,79,90]
      todo.push db.put i,""+i
    await Promise.all todo

  for q in [
    {start:1,end:78} # 迭代不包含end
    {start:78, end:1,reverse:true}
    {start:78,reverse:true}
    {start:1}
    {start:0xFFFFFFFF, reverse:true}
  ]
    console.log q
    for i from db q #反向迭代
      console.log i
    console.log "\n---\n"

  console.log "db.length", db.length
  console.log "\n---\n"

  await db.rmEnd 3
  print()

  db.length = 1
  print()
  t.equal(db.length, 1)


  t.end()
