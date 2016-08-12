# Homepage (Root path)
enable :sessions

helpers do

  def current_user
    User.find(session["user_id"])
  end

  def is_logged_in?
    session["user_id"] != nil
  end

  def login(user)
    session["user_id"] = user.id
  end

  def logout
    session.destroy

  end

end

get '/' do
  @songs = Song.order(num_upvotes: :desc)
  erb :'songs/index'
end

get '/accounts/signup' do
  erb :'accounts/signup'
end

post '/accounts/signup' do
  @user = User.new(params[:user])
  @user.songs << Song.new(params[:song])
  if @user.save
    login(@user)
    redirect '/'
  else
    erb :'/accounts/signup'
  end
end

get '/test' do
  erb :'/test'
end

post '/test' do
  puts params
  flash[:notice] = "Test complete!"
  redirect '/test'
end

namespace '/accounts' do

  get '/login' do
    erb :'accounts/login'
  end

  post '/login' do
    @user = User.find_by(
      username: params["username"],
      password: params[:password]
    )
    if @user
      login(@user)
      redirect '/'
    else
      flash[:message] = "Invalid Login"
      redirect '/accounts/login'
    end
  end

  get '/logout' do
    logout
    redirect '/'
  end

end

get '/songs/new' do
  if current_user
    erb :'songs/new'
  else
    redirect '/'
  end
end

get '/reviews/:song_id' do
  @user = current_user
  @song = Song.find_by(id: params[:song_id])
  @reviews = Review.where(song_id: params[:song_id]).order(:created_at)
  erb :'reviews/list'
end

post '/reviews/delete' do
  @review = Review.find_by(user_id: current_user.id, song_id: params[:song_id])
  @review.destroy
  redirect '/reviews/'+params[:song_id]
end

post '/reviews/:song_id' do
  @user = current_user
  @reviews = Review.where(song_id: params[:song_id]).order(:created_at)
  @song = Song.find_by(id: params[:song_id])
  @review = Review.new(song_id: params[:song_id], content: params[:content], user_id: @user.id, rating: params[:rating])
  if @review.save
    redirect '/reviews/'+params[:song_id]
  else
    erb :'reviews/list'
  end
end



post '/songs' do
  @song = Song.new(
    title: params[:title],
    author: params[:author],
    url: params[:url]
  )

  if current_user && @song.save
    @song.user = current_user
    @song.save
    redirect '/'
  else
    @song = Song.new(
    title: params[:title],
    author: params[:author],
    url: params[:url]
      )
    erb :'/songs/new'
  end
end

post '/songs/upvote/:id' do
  @user = current_user
  @upvote = Upvote.new(user_id: @user.id, song_id: params[:id])
  unless @upvote.save
    existing_upvote = Upvote.find_by(user_id: @user.id, song_id: params[:song_id])
    existing_upvote.destroy
  end
  redirect '/'
end
