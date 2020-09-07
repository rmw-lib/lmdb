#!/usr/bin/env coffee

import lmdb from 'lmdb-store'
import {length} from './const.mjs'

proxy = (db)=>

  rmEnd = (start, n)->
    @transaction =>
      console.log start, n
      for {key} from @getRange {
         reverse:true
         start
      }
        @removeSync key
        if 0 == --n
          break

  if db.keyIsUint32
    rmEnd = rmEnd.bind db, 0xFFFFFFFF
  else
    rmEnd = rmEnd.bind db, undefined


  extend = {
    rmEnd
  }
  new Proxy(
    (opt)=>
      db.getRange opt
    set:(self,name,val)=>
      console.log "set",name,val,"name==length"
      if name == length
        n = db.getStats().entryCount - val
        if n > 0
          return rmEnd n
      return db[name] = val
    get:(self, name)=>
      if name == length
        return db.getStats().entryCount
      else
        func = extend[name]
        if func
          return func
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


