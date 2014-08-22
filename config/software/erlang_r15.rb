#
# Copyright 2014 Chef Software, Inc.
#
# All Rights Reserved.
#

name "erlang_r15"
default_version "R15B03-1"

dependency "zlib"
dependency "openssl"
dependency "ncurses"

source url: "http://www.erlang.org/download/otp_src_#{version}.tar.gz"

version "R15B03-1" do
  source md5:   "eccd1e6dda6132993555e088005019f2"
  relative_path "otp_src_R15B03"
end

version "R16B03-1" do
  source md5:   "e5ece977375197338c1b93b3d88514f8"
  relative_path "otp_src_#{version}"
end

version "R15B02" do
  source md5:   "ccbe5e032a2afe2390de8913bfe737a1"
  relative_path "otp_src_#{version}"
end

build do
  env = with_standard_compiler_flags(with_embedded_path).merge(
    # WARNING!
    "CFLAGS"  => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/#{name}/include",
    "LDFLAGS" => "-Wl,-rpath #{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/#{name}/include"
  )

  # Setup the erlang include dir
  mkdir "#{install_dir}/embedded/#{name}/include"

  # At this time, erlang does not expose a way to specify the path(s) to these
  # libraries, but it looks in its local +include+ directory as part of the
  # search, so we will symlink them here so they are picked up.
  #
  # In future releases of erlang, someone should check if these flags (or
  # environment variables) are avaiable to remove this ugly hack.
  %w(ncurses).each do |name|
    link "#{install_dir}/embedded/include/#{name}", "#{install_dir}/embedded/#{name}/include/#{name}"
  end

  command "./configure" \
          " --prefix=#{install_dir}/embedded/#{name}" \
          " --enable-threads" \
          " --enable-smp-support" \
          " --enable-kernel-poll" \
          " --enable-dynamic-ssl-lib" \
          " --enable-shared-zlib" \
          " --enable-hipe" \
          " --without-javac" \
          " --with-ssl=#{install_dir}/embedded" \
          " --disable-debug", env: env

  make "-j #{max_build_jobs}", env: env
  make "install", env: env
end
