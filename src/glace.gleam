/// glace - the easy-to-use, fast-to-build framework for buidling performant APIs
import glace/internal/glace_builder
import glace/internal/glace_logger
import glace/internal/glace_response
import glace/internal/glace_router
import glace/internal/glace_types
import gleam/erlang/process
import gleam/http/response
import gleam/otp/supervisor
import mist

/// A glace request that's a wrapper over gleam/http/request
pub type Request(context) =
  glace_types.Request(context)

/// A glace response that's a wrapper over gleam/http/response and mist.ResponseData
pub type Response =
  response.Response(mist.ResponseData)

/// Creates a new glace builder that allows chaining subsequent functions
/// 
/// This is the entry point to setting `glace`
/// 
/// Usage:
///
/// ```gleam
/// 
/// glace.new()
/// 
/// ```
pub fn new() -> glace_types.GlaceBuilder(context) {
  glace_builder.new()
}

/// Sets the port
/// 
/// By default, glace starts listening on port 4000
/// 
/// Using this function overrides the default port
/// 
/// Usage:
/// 
/// ```gleam
/// glace.new
/// |> glace.port(3000)
/// ```
pub fn port(
  builder: glace_types.GlaceBuilder(context),
  port: Int,
) -> glace_types.GlaceBuilder(context) {
  glace_builder.port(builder, port)
}

/// Starts the server
/// 
/// This is usually the last step in the pipeline
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.text("Hello, World!") })
/// |> glace.start()
/// 
/// ```
pub fn start(
  builder: glace_types.GlaceBuilder(Nil),
) -> process.Subject(supervisor.Message) {
  glace_builder.start_with_context(builder, Nil)
}

/// Starts the server with a context that will be forwarded for each request
/// 
/// This is usually the last step in the pipeline (same as `start()` but with `context`)
/// 
/// Usage:
/// 
/// ```gleam
/// let context = Context(db: "app.db")
/// 
/// glace.new()
/// |> glace.get("/", fn(req) { handle_request(req) })
/// |> glace.start_with_context(context)
/// 
/// fn handle_request(req: Request) -> Response {
///   let db = request.context.db
///   c.text("Connected to db", 200)
/// }
/// ```
pub fn start_with_context(
  builder: glace_types.GlaceBuilder(context),
  context,
) -> process.Subject(supervisor.Message) {
  glace_builder.start_with_context(builder, context)
}

/// Configures a custom logger and overrides the default logger
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.configure_logger(info, debug, warn, error)
/// |> glace.get("/", fn(req) { handle_request(req) })
/// |> glace.start()
/// 
/// fn info(message: String) {
///   io.println("Info: " <> message) // This can write to any other destination using any logging library
///   Nil
/// }
/// 
/// fn debug(message: String) {
///   io.println("Debug: " <> message)
///   Nil
/// }
/// 
/// fn warn(message: String) {
///   io.println("Warning: " <> message)
///   Nil
/// }
/// 
/// fn error(message: String) {
///   io.println("Error: " <> message)
///   Nil
/// }
/// 
/// fn handle_request(req: Request) -> Response {
///   req.logger.info("Received request: " <> req.path)
///   c.text("Connected to db", 200)
/// }
///  
/// ```
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

/// Registers a GET request for the specified path
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.text("Hello, World!") })
/// |> glace.start()
/// 
/// ```
pub fn get(
  builder: glace_types.GlaceBuilder(context),
  path: String,
  handler: fn(glace_types.Request(context)) -> Response,
) -> glace_types.GlaceBuilder(context) {
  glace_router.get(builder, path, handler)
}

/// Registers a POST request for the specified path
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.post("/", fn(_) { glace.text("Hello, World!") })
/// |> glace.start()
/// 
/// ```
pub fn post(
  builder: glace_types.GlaceBuilder(context),
  path: String,
  handler: fn(glace_types.Request(context)) -> Response,
) -> glace_types.GlaceBuilder(context) {
  glace_router.post(builder, path, handler)
}

/// Helper function to return text response for a request
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.text("Hello, World!") })
/// |> glace.start()
/// 
/// ```
pub fn text(body input: String, status status: Int) -> Response {
  glace_response.text(input, status)
}

/// Helper function to return json response for a request
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.json_string("{\"hello\": \"world\"}") })
/// |> glace.start()
/// 
/// ```
pub fn json_string(body input: String, status status: Int) -> Response {
  glace_response.json(input, status)
}

/// Helper function to return html response for a request
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.html("Hello, World!") })
/// |> glace.start()
/// 
/// ```
pub fn html(body input: String, status status: Int) -> Response {
  glace_response.html(input, status)
}

/// Helper function to return a `404` response for a request
/// 
/// Usage:
/// 
/// ```gleam
/// 
/// glace.new()
/// |> glace.get("/", fn(_) { glace.not_found() })
/// |> glace.start()
/// 
/// ```
pub fn not_found() -> Response {
  glace_response.not_found()
}
