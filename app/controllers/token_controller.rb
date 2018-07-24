class TokenController < ApplicationController
  def show
    if access_token = AccessToken.find_by(code: params[:id])
      redirect_to access_token.path_with_token
    else
      flash[:notice] = "The link you requested has expired."
      redirect_to root_path
    end
  end
end
