import gleam/dict
import gleam/http.{type Header, type Scheme}
import gleam/http/response.{type Response}
import gleam/option.{type Option}
import mist.{type Connection, type ResponseData}

pub type GlaceBuilder(context) {
  GlaceBuilder(
    port: Int,
    routes: List(Route(context)),
    pre_middlewares: List(Middleware(context)),
    post_middlewares: List(Middleware(context)),
    logger: Logger,
  )
}

pub type Route(context) {
  Route(
    method: http.Method,
    path: String,
    handle: fn(Request(context)) -> Response(ResponseData),
  )
}

pub type Config(context) {
  Config(port: Option(Int), routes: List(Route(context)))
}

pub type Middleware(context) {
  Middleware(
    path: String,
    handle: fn(Request(context)) ->
      Result(Request(context), Response(ResponseData)),
  )
}

pub type ExecuteMiddleware {
  Before
  After
}

pub type Request(context) {
  Request(
    method: http.Method,
    headers: List(Header),
    body: Connection,
    scheme: Scheme,
    host: String,
    port: Option(Int),
    path: String,
    query: Option(String),
    params: dict.Dict(String, String),
    context: context,
    logger: Logger,
  )
}

pub type Logger {
  Logger(
    info: fn(String) -> Nil,
    debug: fn(String) -> Nil,
    warn: fn(String) -> Nil,
    error: fn(String) -> Nil,
  )
}
