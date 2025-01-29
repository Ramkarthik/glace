import glace/internal/glace_builder
import glace/internal/glace_logger
import glace/internal/glace_response
import glace/internal/glace_router
import glace/internal/glace_types
import gleam/erlang/process
import gleam/http/response
import gleam/otp/supervisor
import mist

pub type Request(context) =
  glace_types.Request(context)

pub type Response =
  response.Response(mist.ResponseData)

pub fn new() -> glace_types.GlaceBuilder(context) {
  glace_builder.new()
}

pub fn port(
  builder: glace_types.GlaceBuilder(context),
  port: Int,
) -> glace_types.GlaceBuilder(context) {
  glace_builder.port(builder, port)
}

pub fn start(
  builder: glace_types.GlaceBuilder(Nil),
) -> process.Subject(supervisor.Message) {
  glace_builder.start_with_context(builder, Nil)
}

pub fn configure_logger(
  builder: glace_types.GlaceBuilder(context),
  info info: fn(String) -> Nil,
  debug debug: fn(String) -> Nil,
  warn warn: fn(String) -> Nil,
  error error: fn(String) -> Nil,
) {
  let logger = glace_logger.custom_logger(info, debug, warn, error)
  glace_types.GlaceBuilder(..builder, logger: logger)
}

pub fn get(
  builder: glace_types.GlaceBuilder(context),
  path: String,
  handler: fn(glace_types.Request(context)) -> Response,
) -> glace_types.GlaceBuilder(context) {
  glace_router.get(builder, path, handler)
}

pub fn post(
  builder: glace_types.GlaceBuilder(context),
  path: String,
  handler: fn(glace_types.Request(context)) -> Response,
) -> glace_types.GlaceBuilder(context) {
  glace_router.post(builder, path, handler)
}

pub fn text(body input: String, status status: Int) -> Response {
  glace_response.text(input, status)
}

pub fn json_string(body input: String, status status: Int) -> Response {
  glace_response.json(input, status)
}

pub fn html(body input: String, status status: Int) -> Response {
  glace_response.html(input, status)
}

pub fn not_found() -> Response {
  glace_response.not_found()
}
