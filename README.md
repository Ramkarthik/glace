# glace

[![Package Version](https://img.shields.io/hexpm/v/glace)](https://hex.pm/packages/glace)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glace/)

**Note: This is still early in the project and not ready for production use**

A framework to build APIs quickly that focuses primarily on:
1. Ease of use
2. Fast to code
3. Performance

... in that order but it's still pretty fast, like really, really fast.

### Installing

`gleam add glace`

### Usage

```gleam
import glace

pub fn main() {

  glace.new()
  |> glace.port(3000) // Skipping this will default to port 4000
  |> glace.get("/", fn(_) { glace.html("Hello, World!", status: 200) })
  |> glace.get("/text", fn(_) { glace.text("A text response", status: 200) })
  |> glace.get("/json", fn(_) { glace.json_string("{\"data\": \"hello\"}", status: 200) })
  |> glace.get("/404", fn(_) { glace.not_found() })
  |> glace.start()
  
}
```

### Benchmarks

```console
$ bombardier -d 10s --fasthttp http://localhost:4000/

Statistics        Avg      Stdev        Max
  Reqs/sec    121995.56    9004.83  145036.35
  Latency        1.02ms   235.46us    23.58ms
  HTTP codes:
    1xx - 0, 2xx - 1220605, 3xx - 0, 4xx - 0, 5xx - 0
    others - 0
  Throughput:    23.40MB/s
```

