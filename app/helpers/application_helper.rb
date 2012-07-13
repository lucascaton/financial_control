# encoding: utf-8
module ApplicationHelper
  def select_for_users(users)
    users.map{ |user| ["#{user.name} (#{user.email})", user.id] }
  end
end
