# https://gist.github.com/2152663
require 'action_dispatch/middleware/static'
module Middleware
  class FileHandler < ActionDispatch::FileHandler
    def initialize(root, assets_path, cache_control)
      @assets_path = assets_path.chomp('/') + '/'
      super(root, cache_control)
    end

    def match?(path)
      path.start_with?(@assets_path) && super(path)
    end
  end

  class CompressedStaticAssets
    def initialize(app, path, assets_path, cache_control=nil)
      @app = app
      @file_handler = FileHandler.new(path, assets_path, cache_control)
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'GET'
        request = Rack::Request.new(env)
        encoding = Rack::Utils.select_best_encoding(
          %w(gzip identity), request.accept_encoding)

        if encoding == 'gzip'
          pathgz = env['PATH_INFO'] + '.gz'
          if match = @file_handler.match?(pathgz)
            # Get the filehandler to serve up the gzipped file,
            # then strip the .gz suffix
            env["PATH_INFO"] = match
            status, headers, body = @file_handler.call(env)
            path = env["PATH_INFO"] = env["PATH_INFO"].chomp('.gz')

            # Set the Vary HTTP header.
            vary = headers["Vary"].to_s.split(",").map { |v| v.strip }
            unless vary.include?("*") || vary.include?("Accept-Encoding")
              headers["Vary"] = vary.push("Accept-Encoding").join(",")
            end

            headers['Content-Encoding'] = 'gzip'
            headers['Content-Type'] =
              Rack::Mime.mime_type(File.extname(path), 'text/plain')
            headers.delete('Content-Length')

            return [status, headers, body]
          end
        end
      end

      @app.call(env)
    end
  end
end