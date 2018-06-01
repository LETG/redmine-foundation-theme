module ProjectsHelper
  def project_dates(project)
    "#{project.starts_date.strftime('%Y')} - #{project.ends_date.strftime('%Y')}"
  end

  def project_coordinators(project)
    members = project.members.includes(:user, :roles).where(roles: { name: 'Coordinateur' })
    members.collect{|m| link_to_user m.user}.join(', ')
  end

  # Renders the projects index
  def render_custom_project_hierarchy(projects)
    render_project_nested_lists(projects) do |project|
      s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'my-project' : nil}")
      s << content_tag('div', "<strong>#{project_dates(project)}</strong> | #{project_coordinators(project)}".html_safe, :class => 'project-details')
      if project.description.present?
        s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
      end
      s
    end
  end

end
