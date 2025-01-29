import gleam/bytes_tree
import gleam/http/response.{type Response}
import mist.{type ResponseData}

pub fn html(body input: String, status status: Int) -> Response(ResponseData) {
  response.new(status)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(input)))
  |> response.set_header("content-type", "text/html")
}

pub fn text(body input: String, status status: Int) -> Response(ResponseData) {
  response.new(status)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(input)))
  |> response.set_header("content-type", "text/plain")
}

pub fn json(body input: String, status status: Int) -> Response(ResponseData) {
  response.new(status)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(input)))
  |> response.set_header("content-type", "application/json")
}

pub fn not_found() -> Response(ResponseData) {
  response.new(404)
  |> response.set_body(mist.Bytes(bytes_tree.from_string("")))
  |> response.set_header("content-type", "text/plain")
}
