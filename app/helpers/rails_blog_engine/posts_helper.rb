module RailsBlogEngine
  module PostsHelper
    # Link to the comments section of a post.
    def link_to_blog_comments_section(post)
      if post.blog_comments.visible.empty?
        link_to(I18n.t('blog_comments.comment'), post_permalink_path(post) + "#comments")
      else
        link_to(pluralize(post.blog_comments.visible.count, 'comment'),
                post_permalink_path(post) + "#comments")
      end
    end
  end
end
