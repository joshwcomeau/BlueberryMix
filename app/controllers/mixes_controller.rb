class MixesController < ApplicationController
  before_action :get_bucket

  def index
    @mixes = AWS::S3::Bucket.find(@bucket).objects

  end

  def new

  end

  def create
    filename = sanitize_filename(params[:mix].original_filename)
    if AWS::S3::S3Object.store(filename, params[:mix].read, @bucket, :access => :public_read)
      redirect_to root_path
    else
      render :new, alert: "Upload failed"
    end


  end

  def destroy
    if (params[:id])
      filename = params[:id] + "." + params[:format]
      AWS::S3::S3Object.find(filename, @bucket).delete
      redirect_to root_path, notice: "File deleted!"
    else
      render text: "No song was found to delete!"
    end
  end

  private

  def get_bucket
    @bucket = ENV["S3_BUCKET"]
  end

  def sanitize_filename(filename)
    returning filename.strip do |name|
     # NOTE: File.basename doesn't work right with Windows paths on Unix
     # get only the filename, not the whole path
     name.gsub!(/^.*(\\|\/)/, '')

     # Strip out the non-ascii character
     name.gsub!(/[^0-9A-Za-z.\-]/, '_')
    end
  end
end
