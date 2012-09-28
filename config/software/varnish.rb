name "varnish"
version "3.0.3"

source :url => "http://repo.varnish-cache.org/source/varnish-3.0.3.tar.gz",
       :md5 => "714310c83fdbd2061d897dacd3f63d8b"

relative_path "varnish"

build do
  command "./configure"
  command "make"
  command "make install"
end
