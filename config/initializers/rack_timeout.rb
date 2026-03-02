# Timeout is configured via RACK_TIMEOUT_SERVICE_TIMEOUT env var (set in deploy.yml)
Rack::Timeout.register_state_change_observer(:honeybadger_notifier) do |env|
  if env[Rack::Timeout::ENV_INFO_KEY]&.state == :timed_out
    Honeybadger.notify(
      error_class: "Rack::Timeout",
      error_message: "Request timed out: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}?#{env['QUERY_STRING']}",
      context: {
        method: env["REQUEST_METHOD"],
        path: env["PATH_INFO"],
        query: env["QUERY_STRING"]
      }
    )
  end
end
