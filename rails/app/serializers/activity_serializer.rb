class ActivitySerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :provider, :url
end
