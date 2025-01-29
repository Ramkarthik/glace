import glace/internal/glace_types.{
  type ExecuteMiddleware, type GlaceBuilder, type Middleware, type Request,
}
import gleam/http/response.{type Response}
import gleam/list
import mist.{type ResponseData}

pub fn execute_middlewares(
  request: Request(context),
  middlewares: List(Middleware(context)),
) -> Result(Request(context), Response(ResponseData)) {
  case middlewares {
    [first, ..rest] ->
      case execute_middleware(request, first) {
        Ok(req) -> execute_middlewares(req, rest)
        Error(error) -> Error(error)
      }
    [] -> Ok(request)
  }
}

pub fn middleware(
  builder: GlaceBuilder(context),
  middleware handler: fn(Request(context)) ->
    Result(Request(context), Response(ResponseData)),
  execute when: ExecuteMiddleware,
) -> GlaceBuilder(context) {
  // TODO: Add validation for path
  let middleware = glace_types.Middleware("/", handler)

  case when {
    glace_types.Before ->
      glace_types.GlaceBuilder(
        ..builder,
        pre_middlewares: list.append(builder.pre_middlewares, [middleware]),
      )
    glace_types.After ->
      glace_types.GlaceBuilder(
        ..builder,
        post_middlewares: list.append(builder.post_middlewares, [middleware]),
      )
  }
}

pub fn execute_middleware(
  request: Request(context),
  middleware: Middleware(context),
) -> Result(Request(context), Response(ResponseData)) {
  middleware.handle(request)
}
