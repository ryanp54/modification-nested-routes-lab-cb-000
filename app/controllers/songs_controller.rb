class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    @artist = Artist.find_by(id: params[:artist_id])
    @song = Song.find_by(id: params[:id])
    if @artist.nil? && @song.nil?
      redirect_to songs_path, alert: "Song not found"
    elsif @song.nil?
      redirect_to artist_songs_path(@artist), alert: "Song not found"
    end
  end

  def new
    if params[:artist_id] && !Artist.exists?(params[:artist_id])
      redirect_to artists_path, alert: "Artist not found."
    else
      @song = Song.new(artist_id: params[:artist_id])
    end
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @artist = Artist.find_by(id: params[:artist_id])
    @song = Song.find_by(id: params[:id])

    if params[:artist_id] && !@artist
      redirect_to artists_path, alert: "Artist not found."
    elsif !@song || (@artist && !@artist.songs.include?(Song.find(params[:id])))
      redirect_to artist_songs_path(@artist), alert: "Song not found."
    else
      @song = Song.find(params[:id])
    end
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end

