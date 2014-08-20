# Disable git caching
# ------------------------------
# use_git_caching false

# Enable S3 asset caching
# ------------------------------
use_s3_caching true
s3_access_key  ENV['AWS_ACCESS_KEY_ID']
s3_secret_key  ENV['AWS_SECRET_ACCESS_KEY']
s3_bucket      ENV['AWS_S3_BUCKET']

# Customize compiler bits
# ------------------------------
build_retries 1
solaris_compiler 'gcc'

# Load additional software
# ------------------------------
# software_gems ['omnibus-software', 'my-company-software']
# local_software_dirs ['/path/to/local/software']
