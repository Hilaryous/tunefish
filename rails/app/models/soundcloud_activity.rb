class SoundcloudActivity < Activity
  before_save :soundcloud_url

  def soundcloud_url
    new_url = "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/#{self.url}&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"
    self.url = new_url
  end
end
