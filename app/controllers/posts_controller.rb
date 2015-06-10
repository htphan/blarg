class PostsController < ApplicationController
  def index
    page = params[:page] || 1
    @posts = self.get_page(page)
    render :index
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end

  def new
    @form = Post.new(title: nil, content: nil, written_at: nil, tags: [])
    render :new
  end

  def create
    tags = params[:tags].split(", ")
    tag_models = tags.map { |tag| Tag.find_or_create_by(name: tag) }
    @post = Post.create(title: params[:title],
                        content: params[:content],
                        written_at: DateTime.now,
                        tags: tag_models)
    redirect_to posts_path
    # redirect_to post_path(@post)
  end

  def edit
    @form = Post.find_by(id: params['id'])
    render :edit
  end

  def update
    @post = Post.find_by(id: params['id'])
    tags = params['tags'].split(", ")
    tag_models = tags.map { |tag| Tag.find_or_create_by(name: tag) }
    @post.update_attributes(title: params['title'], tags: tag_models, 
                            content: params['content'], written_at: DateTime.now)
    redirect_to post_path(@post)
  end

  protected
  def get_page(n)
    page_offset = (n - 1) * 10
    Post.order(written_at: :desc).offset(page_offset).limit(10)
  end
end
