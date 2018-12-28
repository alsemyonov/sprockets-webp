# encoding: utf-8

require 'sprockets/exporters/webp_exporter'

module Sprockets
  module WebP
    class Railtie < ::Rails::Railtie
      initializer :webp, group: :all do |app|
        app.config.assets.configure do |env|
          env.register_exporter 'image/jpeg', Exporters::WebpExporter
          env.register_exporter 'image/png', Exporters::WebpExporter
        end
      end
    end
  end
end
