module PostsHelper
  def post_element_id(post, suffix = nil)
    "post_#{post.id}" << (suffix.nil? ? "" : "_#{suffix}")
  end
end
