import glace

pub fn main() {
  glace.new()
  |> glace.port(3000)
  |> glace.get("/", fn(_) { glace.text("Hello, World!", status: 200) })
  |> glace.start()
}
