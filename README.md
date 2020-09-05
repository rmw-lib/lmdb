<!-- 本文件由 ./readme.make.md 自动生成，请不要直接修改此文件 -->

# @rmw/lmdb

##  安装

```
yarn add @rmw/lmdb
```

或者

```
npm install @rmw/lmdb
```

## 使用

```coffee
#!/usr/bin/env coffee

import Lmdb from '@rmw/lmdb'
# import test from 'tape'

do =>

  lmdb = Lmdb("/tmp/test/lmdb")
  db = lmdb.just_test( # just_test 是数据库名，可以随便定义
    {
      encoding:'binary'
      compression:false
      keyIsUint32:true
    }
  )
  await lmdb => # 开启事务
    todo = []
    for i in [1,2,77,78,79,90]
      todo.push db.put i,""+i
    Promise.all todo

  for q in [
    {start:1,end:78} # 迭代不包含end
    {start:78, end:1,reverse:true}
    {start:78,reverse:true}
    {start:1}
  ]
    console.log q
    for i from db q #反向迭代
      console.log i
    console.log "\n---\n"

  console.log "db.length", db.length
  console.log "\n---\n"

  db.rmEnd 3
  # t.equal db.length , 5
  # t.deepEqual Xxx([1],[2]),[3]
  # t.end()

```

## 关于

本项目隶属于**人民网络([rmw.link](//rmw.link))**代码计划。

![人民网络](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)
