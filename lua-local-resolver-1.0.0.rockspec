package = "lua-local-resolver"
version = "1.0.0"
source = {
   url = "git://github.com/ysugimoto/lua-local-resolver"
}
description = {
   summary = "local ip resolver from hosts file",
   detailed = "Resolve hostname which is written in local hosts definition file (e.g. `/etc/hosts`).",
   homepage = "https://github.com/ysugimoto/lua-local-resolver",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ["local-resolver"] = "local-resolver.lua"
   },
   copy_directories = {
      "tests"
   }
}
