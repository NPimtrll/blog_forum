module ApplicationHelper
  def format_mentions(text)
    text.gsub(/@(\w+)/) do |match|
      username = $1
      if User.exists?(username: username)
        link_to match, user_path(username), class: "text-blue-500 hover:text-blue-700"
      else
        match
      end
    end.html_safe
  end
end
