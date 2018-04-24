require("string")
require("io")
require("table")

-- Check file existence
-- Try to open file with read mode and close immediately
-- If succeed, returns true, otherwise returns false
local function file_exists(filename)
  local fp = io.open(filename, "r")
  if fp then
    fp:close()
    return true
  end
  return false
end

-- Parse host definition line
-- The line will have following format:
--
-- [ip]         [host1] [host2] [...hosts
--
-- This fucntion parse it and divide ip and host array
local function parse_line(line)
  local ip = nil
  local hosts = {}
  for m in line:gmatch("%S+") do
    -- If ip is nil, it's first item
    if ip == nil then
      ip = m
    else
      table.insert(hosts, m)
    end
  end

  return ip, hosts
end

-- Class Definition
local Resolver = {}

-- Create resolver instance
--
-- @param string hostsfile: path to host definition file (e.g. /etc/hosts)
-- @return resolver instance table
Resolver.new = function(hostsfile)
  if not file_exists(hostsfile) then
    return nil, error("Couldn't find " .. hostsfile)
  end

  local instance = { map = {} }
  -- Parse host line and insert to map
  for line in io.lines(hostsfile) do
    local ip, hosts = parse_line(line)
    for _, host in ipairs(hosts) do
      instance.map[host] = ip
    end
  end

  -- resolve() returns ip corresponds to supplied host
  -- If host not exists in map, returns nil
  instance.resolve = function(self, host)
    return instance.map[host]
  end

  return instance, nil
end

return Resolver
