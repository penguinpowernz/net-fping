# Net::Fping

A ruby gem to interface with fping.

## Usage

Pretty straight forward:

```ruby
require 'net/fping'

alive = Fping.alive(["10.0.0.1", "10.0.0.2", "10.0.0.3"])
> ["10.0.0.1", "10.0.0.3"]

alive = Fping.dead(["10.0.0.1", "10.0.0.2", "10.0.0.3"])
> ["10.0.0.2"]

alive = Fping.alive_in_subnet("192.168.0.0/24")
> ["192.168.0.1", "192.168.0.100", "192.168.0.254"]

alive = Fping.alive_in_range("192.168.0.0", "192.168.0.200")
> ["192.168.0.1", "192.168.0.100"]
```
