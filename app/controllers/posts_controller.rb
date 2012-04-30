class PostsController < ApplicationController
  # GET /posts
  def index
    @posts = Post.order("created_at DESC")

    @post = Post.new

    respond_to do |format|
      format.html {}
      format.js {
        @latest_post = Post.find_by_id(params[:latest_post_id])

        unless @latest_post.nil?
          @new_posts = Post.all(:conditions => ["id > ?", @latest_post.id], :order => "id DESC")
        end
      }
    end
  end

  # GET /posts/1
  def show
    @post = Post.find(params[:id])
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post = Post.new(params[:post])

    @post.ip_address = request.remote_ip

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_url, notice: "Post was successfully created." }
        format.js {
          @latest_post = Post.find_by_id(params[:latest_post_id])

          unless @latest_post.nil?
            @new_posts = Post.all(:conditions => ["id > ?", @latest_post.id], :order => "id DESC")
          end

          render "index", notice: "Post was successfully created."
        }
      else
        format.html { render action: "new" }
        format.js { render "index" }
      end
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # PUT /posts/1
  def update
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_url
  end
end
