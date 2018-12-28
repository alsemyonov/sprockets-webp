# encoding: utf-8

module Sprockets
  module WebP
    class Railtie < ::Rails::Railtie
      initializer :webp, group: :all do |app|
        app.config.assets.configure do |env|
          env.register_mime_type 'image/jpeg', extensions: %w[.jpg .jpeg] unless env.mime_types.include? 'image/jpeg'
          env.register_postprocessor 'image/jpeg', :jpeg_webp do |context, data|
            Converter.process(app, context, data)
          end

          env.register_mime_type 'image/png', extensions: %w[.png]  unless env.mime_types.include? 'image/png'
          env.register_postprocessor 'image/png', :png_webp do |context, data|
            Converter.process(app, context, data)
          end
        end
      end
    end
  end
end
