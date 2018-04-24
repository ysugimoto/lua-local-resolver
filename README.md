# lua-local-resolver

Resolve hostname which is written in local hosts definition file (e.g. `/etc/hosts`).

## Motivation

This library will be useful for using `openresty`, this solves some issue about resolving hosts related problems.

- `resty.redis` couldn't resolve `localhost` to `127.0.0.1`
- The `host` argument on `ngx.balancer.set_current_peer()` couldn't accept hostname, only ip address
- When we use `docker` with linking other containers, we want to resolve linked host via `/etc/hosts`

To solve above things, parse host definition file and resolve hostname to local ip address.

## Usage

```lua
-- Add package and require library
package.path = package.path .. ";/path/to/project/lua-local-resolver/?.lua"

local resolver = require "local-resolver"

-- Instantiate with host definition file path
local r = resolver.new("/etc/hosts")

-- Resolve hostname
print(r:resolve("localhost")) -- 127.0.0.1
```

## Author

Yoshiaki Sugimoto

## License

MIT
