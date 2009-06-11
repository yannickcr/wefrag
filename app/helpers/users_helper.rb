module UsersHelper
  def user_actions(user)
    link_to('Déconnexion', session_path, :method => :delete)
  end
end
