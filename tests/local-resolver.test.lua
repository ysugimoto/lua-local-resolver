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

  function TestResolver:testRsolveLocaHostV6()
    local r = Resolver.new("./tests/fixture/hosts_example")

    local ip = r:resolve_v6("localhost")
    lu.assertEquals(ip, "::1")

    lu.assertEquals(r:resolve_v6("ipv6.com"), "1050:0000:0000:0000:0005:0600:300c:326b")
    lu.assertNil(r:resolve("ipv6.com"))
  end


os.exit(lu.LuaUnit.run())
