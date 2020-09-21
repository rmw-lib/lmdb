#!/usr/bin/env coffee

import {open} from 'lmdb-store'
import {length} from './const.mjs'
import {basename} from 'path'

proxy = (db)=>

  # rmEnd = (start, n)->
  #   @transaction =>
  #     for {key} from @getRange {
  #        reverse:true
  #        start
  #     }
  #       @removeSync key
  #       if 0 == --n
  #         break

  if db.keyIsUint32
    # rmEnd = rmEnd.bind db, 0xFFFFFFFF
    init = (opt={})=>
      if not opt.start
        if opt.reverse
          start = 0xFFFFFFFF
        else
          start = 1
        opt.start = start
      db.getRange opt
  else
    # rmEnd = rmEnd.bind db, undefined
    init = (opt={})=>
      db.getRange opt


  extend = {
    # rmEnd
  }
  new Proxy(
    init
    # set:(self,name,val)=>
    #   init
    #   if name == length
    #     n = db.getStats().entryCount - val
    #     if n > 0
    #       return rmEnd n
    #   return db[name] = val
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
  if not opt.name
    opt.name = basename path
  store = open(opt)
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


