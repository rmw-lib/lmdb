#!/usr/bin/env coffee

import lmdb from 'lmdb-store'



proxy = (db)=>
  new Proxy(
    (opt)=>
      db.getRange opt
    get:(self, name)=>
      if name == 'length'
        return db.getStats().entryCount
      else if name == "rmEnd"
        return (n)=>
          console.log n

      db[name]
  )

export default Imdb = (path, opt)=>
  opt = opt or {}
  opt.path = path
  store = lmdb.open(opt)
  openDB = store.openDB
  p = new Proxy(
    (exec)=>
      store.transaction exec
    get:(self, name)=>
      if name == "$"
        return self[name]
      (config)=>
        config.name = name
        proxy store.openDB config
  )
  p.$ = store
  p


