# Net::Fping

A ruby gem to interface with fping.

## Usage

Pretty straight forward:

```ruby
require 'net/fping'

alive = Net::Fping.alive(["10.0.0.1", "10.0.0.2", "10.0.0.3"])
> ["10.0.0.1", "10.0.0.3"]

alive = Net::Fping.dead(["10.0.0.1", "10.0.0.2", "10.0.0.3"])
> ["10.0.0.2"]

alive = Net::Fping.alive_in_subnet("192.168.0.0/24")
> ["192.168.0.1", "192.168.0.100", "192.168.0.254"]

alive = Net::Fping.alive_in_range("192.168.0.0", "192.168.0.200")
> ["192.168.0.1", "192.168.0.100"]
```

You can also specify the following options on each command (defaults as per fping shown):

```ruby
{
  retries: 3,
  count: 1,
  bytes: 56,
  interval: 25,
  timeout: 500
}
```

So this would be a faster way to ping a 16 bit subnet:

```ruby
alive = Net::Fping.alive_in_subnet("172.16.0.0/16", retries: 0)
```

You can also extract latencies:

```ruby
latencies = Net::Fping.latency("4.2.2.2", 68, 6, 1000)
pp latencies
> [
  0,     # LOSS
  13.7,  # MIN
  15.5,  # AVG
  17.3   # MAX
]
```
