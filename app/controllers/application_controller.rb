class ApplicationController < ActionController::Base
  def score_key
    @score_key ||= SecureRandom.uuid
  end

  def get_score
    if session[:score_key] == score_key
      session[:score]
    else
      0
    end
  end

  def save_score(score)
    session[:score] = score
    session[:score_key] = score_key
  end

  private

  def current_user
    @_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end
end
