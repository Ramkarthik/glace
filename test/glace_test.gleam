import glace.{type Request, type Response}
import glace/internal/glace_logger
import glace/internal/glace_types
import gleam/dict
import gleam/http
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn glace_new_test() {
  let new = glace.new()
  let expected = get_builder(4000)

  new
  |> should.equal(expected)
}

pub fn glace_new_with_port_test() {
  let new =
    glace.new()
    |> glace.port(3000)
  let expected = get_builder(3000)

  new
  |> should.equal(expected)
}

pub fn glace_get_test() {
  let new =
    glace.new()
    |> glace.get("/", fn(_) { glace.text("Test", 200) })

  let setup = add_route("/", http.Get, fn(_) { glace.text("Test", 200) })

  list.length(new.routes)
  |> should.equal(list.length(setup.routes))

  let assert Ok(route) = list.first(new.routes)
  let assert Ok(expected_route) = list.first(setup.routes)

  should.equal(route.path, expected_route.path)
  should.equal(route.method, expected_route.method)
}

pub fn glace_post_test() {
  let new =
    glace.new()
    |> glace.post("/create", fn(_) { glace.text("Test", 200) })

  let setup = add_route("/create", http.Post, fn(_) { glace.text("Test", 200) })

  list.length(new.routes)
  |> should.equal(list.length(setup.routes))

  let assert Ok(route) = list.first(new.routes)
  let assert Ok(expected_route) = list.first(setup.routes)

  should.equal(route.path, expected_route.path)
  should.equal(route.method, expected_route.method)
}

pub fn glace_text_test() {
  let res = glace.text(body: "Hello, World!", status: 200)

  res.status
  |> should.equal(200)

  let headers = dict.from_list(res.headers)

  headers
  |> dict.has_key("content-type")
  |> should.be_true()

  let assert Ok(content_type) = dict.get(headers, "content-type")

  should.equal(content_type, "text/plain")
}

pub fn glace_html_test() {
  let res = glace.html(body: "Hello, World!", status: 200)

  res.status
  |> should.equal(200)

  let headers = dict.from_list(res.headers)

  headers
  |> dict.has_key("content-type")
  |> should.be_true()

  let assert Ok(content_type) = dict.get(headers, "content-type")

  should.equal(content_type, "text/html")
}

pub fn glace_json_string_test() {
  let res = glace.json_string(body: "{\"hello\": \"world\"}", status: 200)

  res.status
  |> should.equal(200)

  let headers = dict.from_list(res.headers)

  headers
  |> dict.has_key("content-type")
  |> should.be_true()

  let assert Ok(content_type) = dict.get(headers, "content-type")

  should.equal(content_type, "application/json")
}

pub fn glace_not_found_test() {
  let res = glace.not_found()

  res.status
  |> should.equal(404)
}

fn get_builder(port: Int) -> glace_types.GlaceBuilder(context) {
  glace_types.GlaceBuilder(
    port: port,
    routes: [],
    pre_middlewares: [],
    post_middlewares: [],
    logger: glace_logger.default_logger(),
  )
}

fn add_route(
  path: String,
  method: http.Method,
  handler: fn(Request(context)) -> Response,
) -> glace_types.GlaceBuilder(context) {
  let route = glace_types.Route(method, path, handler)
  let routes: List(glace_types.Route(context)) = [route]
  let builder = glace_types.GlaceBuilder(..get_builder(4000), routes: routes)
  builder
}
