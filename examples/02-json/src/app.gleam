import glace

pub fn main() {
  glace.new()
  |> glace.get("/", fn(_) {
    glace.json_string(body: "{\"hello\": \"world\"}", status: 200)
  })
  |> glace.start()
}
