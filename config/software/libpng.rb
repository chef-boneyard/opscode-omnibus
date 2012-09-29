name "libpng"
version "1.5.12"

dependencies ["zlib"]

source :url => "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-#{version}.tar.gz",
       :md5 => "8ea7f60347a306c5faf70b977fa80e28"

relative_path "libpng-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --with-zlib-prefix=#{install_dir}/embedded", :env => configure_env
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
end
