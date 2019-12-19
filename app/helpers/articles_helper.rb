module ArticlesHelper
  def sanitize_content(text)
    sanitize text, tags: %w(p pre code span blockquote strong ul li ol em u del a), attributes: %w(class target rel title href)
  end
end
