import glace/internal/glace_types.{type Logger, type Request}
import gleam/dict
import gleam/http/request.{type Request as HttpRequest}
import mist.{type Connection}

pub fn make_request(
  request: HttpRequest(Connection),
  params: dict.Dict(String, String),
  context: context,
  logger: Logger,
) -> Request(context) {
  glace_types.Request(
    method: request.method,
    headers: request.headers,
    body: request.body,
    scheme: request.scheme,
    host: request.host,
    port: request.port,
    path: request.path,
    query: request.query,
    params: params,
    context: context,
    logger: logger,
  )
}
