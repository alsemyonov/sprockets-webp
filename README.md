# Sprockets::WebP

[![unstable](https://rawgithub.com/hughsk/stability-badges/master/dist/unstable.svg)](http://github.com/hughsk/stability-badges)

[![Gem Version](https://badge.fury.io/rb/sprockets-webp.png)](http://badge.fury.io/rb/sprockets-webp)
[![Code Climate](https://codeclimate.com/github/alsemyonov/sprockets-webp-exporter.png)](https://codeclimate.com/github/alsemyonov/sprockets-webp-exporter)
[![Dependency Status](https://gemnasium.com/alsemyonov/sprockets-webp-exporter.png)](https://gemnasium.com/alsemyonov/sprockets-webp-exporter)
[![Still Maintained](http://stillmaintained.com/alsemyonov/sprockets-webp-exporter.png)](http://stillmaintained.com/alsemyonov/sprockets-webp-exporter)

[![Coderwall](https://api.coderwall.com/alsemyonov/endorsecount.png)](https://coderwall.com/alsemyonov)

**Warning**: This gem depends on Sprockets 4 (that is in beta right now), because of using new `#register_exporter`.
There is no guarantee for stable API until `sprockets-4.0.0` and `sprockets-webp-exporter-1.0.0` released.

_Big thanks to [Max Riveiro](https://github.com/kavu) for his [sprockets-webp](https://github.com/kavu/sprockets-webp) 
gem that worked with previous versions of Sprockets, but is not working now. I hope we could merge our gems in future._

This gem provides a WebP Exporter for converting PNG and JPEG assets to the WebP format using Sprockets 4.

## Requirements

The main requirement is obviously [libwebp](https://developers.google.com/speed/webp/) itself. Please, consult the [webp-ffi](https://github.com/le0pard/webp-ffi) README for the installation instructions.

## Installation

### Rails 5

If you're using Rails 5 you need to add gem to the ```:production``` group in to your application's Gemfile:

```ruby
group :production do
  # ...
  gem 'sprockets-webp-exporter'
  # ...
end
```

## Configuration

You can configure encode options for webp by using `encode_options` (in example default options):

```ruby
Sprockets::WebP.encode_options = { quality: 100, lossless: 1, method: 6, alpha_filtering: 2, alpha_compression: 0, alpha_quality: 100 }
```

More options you can find in [web-ffi readme](https://github.com/le0pard/webp-ffi#encode-webp-image).

## Testing

Drop some PNGs and JPGs into ```app/assets/images``` and you can test converter locally with the Rake task:

```bash
bundle exec rake assets:precompile RAILS_ENV=production
```

## Web Server

As not all browsers support ``webp`` images (see [Can I Use](http://caniuse.com/webp)), so they need to be served conditionally based on the HTTP ``Accept`` header sent by browsers capable to display this format.

### Nginx

Here is a simple [nginx](http://nginx.org) recipe, which contrary to popular beliefs, do not require ``if`` nor ``rewrite``, instead use lightweight ``map`` and ``try_files``

```nginx
http {
  # IMPORTANT!!! Make sure that mime.types below lists WebP like that:
  # image/webp webp;
  include /etc/nginx/mime.types;

  ##
  # Is webp supported?
  # (needs to be part of http section)
  ##

  map $http_accept $webp_suffix {
    default   "";
    "~*webp"  ".webp";
  }

  ##
  # Server
  ##

  server {
    location ~* ^/images/.+\.(png|jpg)$ {
      if ($webp_suffix != "") {
        add_header Vary Accept;
      }

      try_files $uri$webp_suffix $uri =404;
    }
  }
}
```

Make sure that webp is defined in `mime.types` file:

```nginx
image/webp  webp;
```

## CDN

If you serve your assets using CDN, you need to make sure that it forwards `Accept` header allowing to conditionally choose webp for browsers which support it.

### Amazon AWS CloudFront

Following solution would not work if your CloudFront distribution points to S3. Instead it should point to your webserver, which will host the webp serving logic.

Take following steps to enable `Accept` header forwarding:

* visit your CloudFront distributions page
* select distribution
* choose `Behaviors` tab
* select behaviourrepresenting your assets end hit `Edit`
* select `Whitelist` for the `Forward Headers` option
* add `Accept` to the list on the right
* approve your changes clicking `Yes, Edit`
* wait until refreshed distribution will be deployed

Test with:

```
curl -I -H "Accept: image/webp" http://yourdomain.com/yourimage.png
curl -I http://yourdomain.com/yourimage.png
```

Returned `Content-Type` should be `image/webp` in the first case and `image/png` in the second.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
