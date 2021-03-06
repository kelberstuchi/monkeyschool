class PostsController < ApplicationController



	before_action :find_post, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
	before_action :authenticate_user!, except: [:index,:show]

 
	def index
		@posts = Post.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
		@comments = Comment.all
		@comment = Comment.where(post_id: @post)
		# se quiser selecionar somente post do usuario
			# @posts = Post.where(user_id: current_user)

		@feito = Post.where(done: true)
		@aberto = Post.where(done: false)

	end



	def show
		@comments = Comment.where(post_id: @post).order("created_at DESC")
		@random_post = Post.where.not(id: @post).order("RANDOM()").first
	
	end

	def complete
		@post = Post.find(params[:id])
		@post.update_attribute(:completed_at , Time.now)
		redirect_to @post, notice: "Completed"
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


	def upvote
		@post.upvote_by current_user
		redirect_to :back
	end
	
	def downvote
		@post.downvote_by current_user
		redirect_to :back
	end
					


	private

	def find_post
		@post = Post.find(params[:id])

	end

	def post_params
		params.require(:post).permit(:title, :description, :done, :image)
	end





end
