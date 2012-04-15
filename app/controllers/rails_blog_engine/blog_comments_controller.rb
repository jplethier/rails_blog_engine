module RailsBlogEngine
  class BlogCommentsController < RailsBlogEngine::ApplicationController
    before_filter :load_post

    load_and_authorize_resource :class => "RailsBlogEngine::BlogComment"
    skip_load_resource :create

    def create
      @blog_comment = @post.blog_comments.create(params[:blog_comment]) do |c|
        # Record some extra information from our environment.  Most of this
        # is used by the spam filter.
        c.author_ip = request.remote_ip
        c.author_user_agent = request.env['HTTP_USER_AGENT']
        c.author_can_post = can?(:create, RailsBlogEngine::Post)
        c.referrer = request.env['HTTP_REFERER']
      end

      if @blog_comment.valid?
        @blog_comment.run_spam_filter
        if @blog_comment.filtered_as_spam?
          flash[:comment_notice] = I18n.t('blog_comments.held_for_moderation')
          redirect_to(post_permalink_path(@post) + '#comment-flash')
        else
          redirect_to(post_permalink_path(@post) + "#comment-#{@blog_comment.id}")
        end
      else
        render "new"
      end
    end

    def mark_as_spam
      @blog_comment.mark_as_spam!
      redirect_to(post_permalink_path(@post) + "#comment-#{@blog_comment.id}")
    end

    def mark_as_ham
      @blog_comment.mark_as_ham!
      redirect_to(post_permalink_path(@post) + "#comment-#{@blog_comment.id}")
    end

    protected

    def load_post
      @post = Post.find(params[:post_id])
    end
  end
end
