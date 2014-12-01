class PostsController < ApplicationController

	before_action :find_post, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index,:show]


	def index
		@posts = Post.all.order("created_at DESC")

	end
	def show

	end

	def new
		@post = current_user.posts.new

	end

	def create
		@post = current_user.posts.new(post_params)
		if @post.save
			redirect_to @post, notice: "Created Successfully"
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @post.update(post_params)
			redirect_to @post, notice: "Updated Successfully"
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy
		redirect_to posts_path, notice: "Deleted"
	end

	private

	def find_post
		@post = Post.find(params[:id])

	end

	def post_params
		params.require(:post).permit(:title, :description)
	end





end