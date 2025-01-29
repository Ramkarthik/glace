import glace.{type Request, type Response}

pub fn main() {
  glace.new()
  |> glace.get("/", fn(req) { hello_world(req) })
  |> glace.start()
}

fn hello_world(req: Request(Nil)) -> Response {
  req.logger.info("Request received: " <> req.path)
  glace.text(body: "Hello, World!", status: 200)
}
