module Admin::UsersHelper
  def image_column(record)
    if record.image
      link_to image_tag(record.image.public_filename(:medium)), image_path(record.image.public_filename)
    else
      '-'
    end
  end

  def state_column(record)
    User.states[record.current_state]
  end

  def age_form_column(record, input_name)
    if age = record.age
      age.to_s + ' ans'
    else
      '-'
    end
  end

  def gender_form_column(record, input_name)
    select(:record, :gender, { 'Masculin' => :male, 'Féminin' => :female })
  end

  def country_form_column(record, input_name)
    select :record, :country, User.countries, :include_blank => true
  end

  def image_form_column(record, input_name)
    image_column record
  end

  def image_code_form_column(record, input_name)
    record.image_code
  end

  def birthdate_form_column(record, input_name)
    date_select :record, :birthdate, :name => input_name, :start_year => Time.now.year, :end_year => 1900, :include_blank => true
  end

  def state_action_form_column(record, input_name)
    state = content_tag :strong, User.states[record.current_state]

    if record.confirmed?
      values = { 'Accepter' => :accept, 'Refuser' => :refuse }
    elsif record.active?
      values = { 'Désactiver' => :disable }
    elsif record.disabled?
      values = { 'Réactiver' => :enable }
    else
      return state
    end

    select(:record, :state_action, values, :include_blank => true) + ' (Current: ' + state + ')'
  end
end
