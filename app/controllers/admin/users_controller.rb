class Admin::UsersController < Admin::ApplicationController
  layout 'admin'
  active_scaffold do |config|
    config.columns.add [:state_action, :image_code, :age]

    # Labels
    { :login => 'Identifiant', :email => 'E-mail', :state => 'Etat', :is_admin => 'Admin ?',
      :group => 'Groupe', :state_action => 'Modifier l\'état', :birthdate => 'Date de naissance', :age => 'Age',
      :gender => 'Sexe', :first_name => 'Prénom', :last_name => 'Nom', :city => 'Ville', :country => 'Pays', :image => 'Photo',
      :image_code => 'Code', :created_at => 'Créé le', :updated_at => 'Màj le' }.each do |key, value|
      config.columns[key].label = value #if config.columns[key]
    end
 
    config.columns[:login].set_link :edit
    config.columns[:group].form_ui = :select
    config.columns[:is_admin].form_ui = :checkbox

    config.list.columns   = [:id, :login, :email, :state, :is_admin, :group, :created_at]
    config.show.columns   = \
    config.create.columns = \
    config.update.columns = [:login, :email, :state, :state_action, :is_admin, :group, :birthdate, :age, :gender, :first_name, :last_name, :city, :country, :image_code, :image]
    config.create.columns.remove [:image, :image_code, :state_action, :age]
    config.update.columns.remove :state
    config.show.columns.remove   :state_action
  end

  def conditions_for_collection
    if params[:to_activate]
        ['users.state = ? AND ' +
         'users.first_name IS NOT NULL AND users.first_name != \'\' AND ' +
         'users.last_name  IS NOT NULL AND users.last_name  != \'\' AND ' +
         'users.city       IS NOT NULL AND users.city       != \'\' AND ' +
         'users.country    IS NOT NULL AND users.country    != \'\' AND ' +
         'users.birthdate  IS NOT NULL AND users.birthdate  != \'\' AND ' +
         'users.image_id   IS NOT NULL', 'confirmed']
    end
  end
end

class User
  after_save :state_action!
  attr_accessor :state_action

  def authorized_for_destroy?
    return !current_user || (current_user.id != id)
  end

  private

  def state_action!
    case state_action
      when 'accept'
        accept!
        activate!
      when 'refuse'
        refuse!
      when 'disable'
        disable!
      when 'enable'
        enable!
    end
  end
end
