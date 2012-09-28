name "libpng"
version "1.5.13"

dependencies ["zlib"]

source :url => "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-#{version}.tar.gz",
       :md5 => "9c5a584d4eb5fe40d0f1bc2090112c65"

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
