module StaticPagesHelper

  def detect_ie
    user_agent = request.env['HTTP_USER_AGENT'].downcase
    if user_agent =~ /msie/i
      true
    end
  end
end
