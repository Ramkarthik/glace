# glace

A framework to build API quickly that focuses primarily on:
1. Ease of use
2. Fast to code
3. Performance

...in that order but it's still pretty fast, like really, really fast.

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
