class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    @identity = Identity.find_from_hash(auth)
    if @identity.nil?
      @identity = Identity.create_from_hash(auth, current_user)
      if auth['provider'] == 'soundcloud'
        @identity.user.update_attributes(soundcloud_user_id: auth['extra']['raw_info']['id'])
      end
    end
    # Save soundcloud activit y

    if signed_in?
      if @identity.user == current_user
        render :close_window
      else
        @identity.user = current_user
        @identity.save
        render :close_window
      end
    else
      if @identity.user.present?
        self.current_user = @identity.user
        render :close_window
      else
        render :close_window
      end
    end
    if auth['provider'] == 'google_oauth2'
      binding.pry
      params[:subscriptions_hash] = @identity.user.subscriptions(YoutubeAPI.get_subscriptions(current_user))
      @identity.user.add_tracked_subscriptions(params[:subscriptions_hash])
    elsif auth['provider'] == 'soundcloud' && @identity.user.soundcloud_user_id.nil?
      @identity.user.update_attributes(soundcloud_user_id: auth['extra']['raw_info']['id'])
    end
     SoundcloudAPIWorker.perform_async(@identity.user.soundcloud_user_id, @identity.user.id)
  end
end
