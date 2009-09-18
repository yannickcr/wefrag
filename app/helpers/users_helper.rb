module UsersHelper
  def user_actions(user)
    link_to('Déconnexion', my_session_path, :method => :delete)
  end
end
