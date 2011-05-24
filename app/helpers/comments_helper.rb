module CommentsHelper

  # Linkify comment text
  # From: http://snippets.dzone.com/posts/show/7455
  def linkify( text )
    @generic_URL_regexp = Regexp.new( '(^|[\n ])([\w]+?://[\w]+[^ \"\n\r\t<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
    @starts_with_www_regexp = Regexp.new( '(^|[\n ])((www)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
    @starts_with_ftp_regexp = Regexp.new( '(^|[\n ])((ftp)\.[^ \"\t\n\r<]*)', Regexp::MULTILINE | Regexp::IGNORECASE )
    @email_regexp = Regexp.new( '(^|[\n ])([a-z0-9&\-_\.]+?)@([\w\-]+\.([\w\-\.]+\.)*[\w]+)', Regexp::IGNORECASE )

    s = text.to_s
    s.gsub!( @generic_URL_regexp, '\1<a target="_extlink" href="\2">\2</a>' )
    s.gsub!( @starts_with_www_regexp, '\1<a target="_extlink" href="http://\2">\2</a>' )
    s.gsub!( @starts_with_ftp_regexp, '\1<a target="_extlink" href="ftp://\2">\2</a>' )
    s.gsub!( @email_regexp, '\1<a target="_extlink" href="mailto:\2@\3">\2@\3</a>' )
    s.html_safe
  end

end
