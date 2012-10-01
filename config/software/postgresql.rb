name "postgresql"
version "9.1.6"

dependencies ["zlib",
              "openssl",
              "readline",
              "ncurses"]

source :url => "http://ftp.postgresql.org/pub/source/v9.1.6/postgresql-9.1.6.tar.gz",
       :md5 => "d04593edd0c0b724a8eaad91bf4d7093"

relative_path "postgresql-9.1.6"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  patch :source => 'postgresql-9.1.6-configure-ncurses-fix.patch'
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--with-openssl --with-includes=#{install_dir}/embedded/include",
           "--with-libraries=#{install_dir}/embedded/lib"].join(" "), :env => configure_env
  command "make -j #{max_build_jobs}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "make install"
end
