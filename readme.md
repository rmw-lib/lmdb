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

```
import Lmdb from '@rmw/lmdb'

lmdb = Lmdb("/tmp/test")
db = lmdb.db({
  encoding:'binary'
  compression:false
  keyIsUint32:true
})

do =>
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

  console.log db.length
```

## 关于

本项目隶属于**人民网络([rmw.link](//rmw.link))** 代码计划。

![人民网络](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)
