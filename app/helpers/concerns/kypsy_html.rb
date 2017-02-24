class #{t(:brand)}HTML < Redcarpet::Render::HTML
  def postprocess(html)
    html = autolink_at_usernames(html)
    autolink_searches(html)
  end

  def autolink_at_usernames(html)
    html.gsub(/(\W|>)(@[\.a-zA-Z0-9_-]+)/) do |m|
      chomped = $2[-1] == "."
      "#{$1}<a href='/#{$2.chomp('.')}'>#{$2.chomp('.')}</a>#{'.' if chomped}"
    end
  end

  def autolink_searches(html)
    html.gsub(/\s(#([\.a-zA-Z0-9_-]+))/) do |m|
      chomped = $1[-1] == "."
     " <a href='/people?search=#{$2.chomp('.')}'>#{$1.chomp('.')}</a>#{'.' if chomped}"
    end
  end

end
