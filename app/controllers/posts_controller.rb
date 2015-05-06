class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :reply]
  before_action :authenticate_user!
  load_and_authorize_resource

   # GET /posts
  def index
    @posts = Post.all
    @posts = Post.page(params[:page]).per(10)
    respond_to do |format|
      format.html { render }
      format.json do
        render json: @posts
      end
    end
  end

  def hottest
    @posts = Post.hottest
    render :index
  end

  # GET /posts/1
  def show
    @post.clicks += 1
    @post.save
    @mark = @post.replies
    @mark = @mark.page(params[:page]).per(5)
   end

  def reply
    @post.replies.create(
      body: params[:reply][:body],
      author: current_user
    )
    redirect_to :back, notice: "Reply created successfully"
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    @post.author = current_user

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end

