import glace/internal/glace_logger
import glace/internal/glace_middleware
import glace/internal/glace_request
import glace/internal/glace_response
import glace/internal/glace_router
import glace/internal/glace_types.{type GlaceBuilder}
import gleam/dict
import gleam/erlang/process
import gleam/http/request.{type Request as HttpRequest}
import gleam/http/response.{type Response}
import gleam/otp/supervisor
import mist.{type Connection, type ResponseData}

pub fn new() -> glace_types.GlaceBuilder(context) {
  glace_types.GlaceBuilder(
    port: 4000,
    routes: [],
    pre_middlewares: [],
    post_middlewares: [],
    logger: glace_logger.default_logger(),
  )
}

pub fn port(builder: GlaceBuilder(context), port: Int) -> GlaceBuilder(context) {
  glace_types.GlaceBuilder(..builder, port: port)
}

pub fn start_with_context(
  builder: GlaceBuilder(context),
  context,
) -> process.Subject(supervisor.Message) {
  let assert Ok(process) =
    fn(req: HttpRequest(Connection)) -> Response(ResponseData) {
      let request =
        glace_request.make_request(req, dict.new(), context, builder.logger)
      let res = case
        glace_middleware.execute_middlewares(request, builder.pre_middlewares)
      {
        Ok(req) -> {
          case glace_router.match_route(req, builder.routes) {
            Ok(response) ->
              case
                glace_middleware.execute_middlewares(
                  req,
                  builder.post_middlewares,
                )
              {
                Ok(_req) -> response
                Error(error) -> error
              }
            Error(Nil) -> glace_response.not_found()
          }
        }
        Error(error) -> error
      }
      res
    }
    |> mist.new
    |> mist.port(builder.port)
    |> mist.start_http

  process.sleep_forever()

  process
}
