name "varnish"
version "3.0.3"

source :url => "http://repo.varnish-cache.org/source/varnish-3.0.3.tar.gz",
       :md5 => "714310c83fdbd2061d897dacd3f63d8b"

relative_path "varnish"

env =
  case platform
  when "solaris2"
    {
      "LDFLAGS" => "-R #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
    }
  else
    {
      "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
      "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
      "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
    }
  end

build do
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make", :env => env
  command "make install"
end
