require 'sprockets/exporters/base'
require 'webp-ffi'

module Sprockets
  module Exporters
    # Generates a `.webp` file using the webp-ffi
    class WebpExporter < Exporters::Base
      def setup
        @webp_target = "#{ target }.webp"
      end

      def skip?(logger)
        if ::File.exist?(@webp_target)
          logger.debug "Skipping #{ @webp_target }, already exists"
          true
        else
          logger.info "Writing #{ @webp_target }"
          false
        end
      end

      def call
        ::WebP.encode(target, @webp_target, Sprockets::WebP.encode_options)
      end
    end
  end
end
