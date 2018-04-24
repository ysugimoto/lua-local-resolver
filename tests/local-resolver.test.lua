package.path = package.path ..';../?.lua'

local lu = require("luaunit")
local Resolver = require("local-resolver")

TestResolver = {}
  function TestResolver:testResolveLocalHost()
    local r = Resolver.new("./tests/fixture/hosts_example")

    local ip = r:resolve("localhost")
    lu.assertEquals(ip, "127.0.0.1")

    -- multiple hosts also resolve
    lu.assertEquals(r:resolve("localhost.localdomain"), "127.0.0.1")

    -- Tabbed separete host also resolve
    lu.assertEquals(r:resolve("example.com"), "192.168.0.1")

  end

  function TestResolver:testResolveUnknown()
    local r = Resolver.new("./tests/fixture/hosts_example")
    local ip = r:resolve("unknown")
    lu.assertNil(ip)
  end


os.exit(lu.LuaUnit.run())
