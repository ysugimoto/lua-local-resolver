# lua-local-resolver

Resolve hostname which is written in local hosts definition file (e.g. `/etc/hosts`).

## Motivation

This library will be useful for using `openresty`, this solves some issue about resolving hosts related problems.

- `resty.redis` couldn't resolve `localhost` to `127.0.0.1`  -- [issue](https://github.com/openresty/lua-resty-redis/issues/59)
- The `host` argument on `ngx.balancer.set_current_peer()` couldn't accept hostname, only ip address -- [issue](https://github.com/openresty/lua-resty-core/issues/45)
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

## With Openresty

Intialize at `init_by_lua` directive:

```lua
init_by_lua_block {
  local resolver = require "local-resolver"

  -- expose global as we expect
  resolver = resolver.new("/etc/hosts")
}
```

and use it following directives.

Balancer example:

```lua
balancer_by_lua_block {
  local balancer = require "ngx.balancer"
  -- resolve localhost to ip
  local ok, err = balancer.set_current_peer(resolver:resolve("localhost"), 80)
  ...

  -- Or, use linked docker container name
  local ok, err = balancer.set_current_peer(resolver:resolve("docker-linked-name"), 80)
  ...
}
```

Redis example:

```lua
content_by_lua_block {
  local redis = require "resty.redis"
  local r = redis:new()

  -- connect with hostname
  local ok, err = r:connect(resolver:resolve("localhost"), 6379)
  ...
}
```

No longer you don't need to define environment variable like `REDIS_HOST` at `nginx.conf` :)


## Note

Of course this library `only` resolves local definition hosts.
So, if you want to resolve external hosts, we prefer to use [lua-resty-dns](https://github.com/openresty/lua-resty-dns), it is bundled in `openresty`.

## Author

Yoshiaki Sugimoto

## License

MIT
