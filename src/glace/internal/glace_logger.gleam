import glace/internal/glace_types
import logging

pub fn default_logger() -> glace_types.Logger {
  glace_types.Logger(info, debug, warn, error)
}

pub fn custom_logger(
  info info: fn(String) -> Nil,
  debug debug: fn(String) -> Nil,
  warn warn: fn(String) -> Nil,
  error error: fn(String) -> Nil,
) {
  glace_types.Logger(info: info, debug: debug, warn: warn, error: error)
}

fn info(message: String) {
  logging.log(logging.Info, message)
  Nil
}

fn debug(message: String) {
  logging.log(logging.Debug, message)
  Nil
}

fn warn(message: String) {
  logging.log(logging.Warning, message)
  Nil
}

fn error(message: String) {
  logging.log(logging.Error, message)
  Nil
}
