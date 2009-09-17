module UsersHelper
  def user_actions(user)
    link_to('Déconnexion', user_session_path, :method => :delete)
  end
end
