import glace/internal/glace_types.{type GlaceBuilder, type Request, type Route}
import gleam/http
import gleam/http/response.{type Response}
import gleam/list
import mist.{type ResponseData}
import pathern

pub fn get(
  builder: glace_types.GlaceBuilder(context),
  path: String,
  handler: fn(Request(context)) -> Response(ResponseData),
) -> GlaceBuilder(context) {
  // TODO: Add validation for path
  let route = glace_types.Route(http.Get, path, handler)
  glace_types.GlaceBuilder(
    ..builder,
    routes: list.append(builder.routes, [route]),
  )
}

pub fn post(
  builder: GlaceBuilder(context),
  path: String,
  handler: fn(Request(context)) -> Response(ResponseData),
) -> GlaceBuilder(context) {
  // TODO: Add validation for path
  let route = glace_types.Route(http.Post, path, handler)
  glace_types.GlaceBuilder(
    ..builder,
    routes: list.append(builder.routes, [route]),
  )
}

pub fn match_route(
  request: Request(context),
  routes: List(Route(context)),
) -> Result(Response(ResponseData), Nil) {
  let allowed_routes =
    routes
    |> list.filter(fn(route) { route.method == request.method })

  let allowed_route_paths =
    allowed_routes
    |> list.map(fn(route) { route.path })

  case pathern.match_patterns(request.path, allowed_route_paths) {
    Ok(pattern) -> {
      case
        allowed_routes
        |> list.find(fn(route) { route.path == pattern.pattern })
      {
        Ok(route) -> {
          let request = glace_types.Request(..request, params: pattern.params)
          Ok(route.handle(request))
        }
        Error(Nil) -> Error(Nil)
      }
    }
    Error(_) -> Error(Nil)
  }
}
