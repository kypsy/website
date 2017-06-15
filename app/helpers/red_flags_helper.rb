module RedFlagsHelper

  def red_flag_classes(count)
    classes = []
    classes << "red-flag"
    classes << "danger" if count > 1
    classes.join(" ")
  end

  def flagged?(obj)
    return unless current_user
    current_user.red_flag_reports.where(flaggable_id: obj.id, flaggable_type: obj.class.to_s).any?
  end

  def unflag_button(obj, options={})
    flag = current_user.red_flag_reports.find_by(flaggable_id: obj.id, flaggable_type: obj.class.to_s)
    link_to "#{fa_icon :flag}&nbsp;&nbsp;#{t 'buttons.unflag_button_text'} #{t 'buttons.flag_as_what_button_text'}".html_safe,
            flag_path(flag.id),
            { method: :delete }.merge(options)
  end

end
