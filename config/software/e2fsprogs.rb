name "e2fsprogs"
version "v1.42.4"

dependencies ["autoconf", "automake", "libiconv"]

source :git => "git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git"

relative_path "e2fsprogs"

build_dir = "#{project_dir}/build"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -L/lib -L/usr/lib",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV["PATH"]}"
}

build do
  command "mkdir build"
  command(["../configure",
           "--enable-elf-shlibs",
           "--with-libiconv-prefix=#{install_dir}/embedded",
           "--prefix=#{install_dir}/embedded"].join(" "),
           :cwd => build_dir,
           :env => configure_env)
  command "make", :cwd => build_dir, :env => configure_env
  command "make install", :cwd => build_dir, :env => configure_env
  command "make install-libs", :cwd => build_dir, :env => configure_env
end
