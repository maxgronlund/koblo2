# From http://marsorange.com/archives/of-mogrify-ruby-tempfile-dynamic-class-definitions
class TempfileWithExtension < Tempfile
  def make_tmpname(basename, n)
    # force tempfile to use basename's extension if provided
    ext = File::extname(basename)
    # force hyphens instead of periods in name
    n ||= 0
    sprintf('%s%d-%d%s', File::basename(basename, ext), $$, n, ext)
  end
end
