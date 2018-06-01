ApplicationHelper.class_eval do

  # Renders the project quick-jump box
  def render_public_project_jump_box
    # return unless User.current.logged?
    # projects = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
    projects = User.current.logged? ? User.current.memberships.collect(&:project).compact.select(&:active?).uniq : Project.all_public.select(&:active?).uniq
    if projects.any?
      options =
        ("<option value=''>#{ l(:label_jump_to_a_project) }</option>" +
         '<option value="" disabled="disabled">---</option>').html_safe

      options << project_tree_options_for_select(projects, :selected => @project) do |p|
        { :value => project_path(:id => p, :jump => current_menu_item) }
      end

      select_tag('project_quick_jump_box', options, :onchange => 'if (this.value != \'\') { window.location = this.value; }')
    end
  end

  def project_settings_tabs2
    tabs = [{:name => 'info', :action => :edit_project, :partial => 'projects/edit', :label => :label_information_plural},
            # {:name => 'modules', :action => :select_project_modules, :partial => 'projects/settings/modules', :label => :label_module_plural},
            {:name => 'members', :action => :manage_members, :partial => 'projects/settings/members', :label => :label_member_plural},
            # {:name => 'versions', :action => :manage_versions, :partial => 'projects/settings/versions', :label => :label_version_plural},
            # {:name => 'categories', :action => :manage_categories, :partial => 'projects/settings/issue_categories', :label => :label_issue_category_plural},
            # {:name => 'wiki', :action => :manage_wiki, :partial => 'projects/settings/wiki', :label => :label_wiki},
            # {:name => 'repositories', :action => :manage_repository, :partial => 'projects/settings/repositories', :label => :label_repository_plural},
            # {:name => 'boards', :action => :manage_boards, :partial => 'projects/settings/boards', :label => :label_board_plural},
            # {:name => 'activities', :action => :manage_project_activities, :partial => 'projects/settings/activities', :label => :enumeration_activities}
            ]
    tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
  end

  def page_header_title
    if @project.nil? || @project.new_record?
      h(Setting.app_title)
    else
      b = []
      ancestors = (@project.root? ? [] : @project.ancestors.visible.to_a)
      if ancestors.any?
        root = ancestors.shift
        b << link_to_project(root, {:jump => current_menu_item}, :class => 'root')
        if ancestors.size > 2
          b << "\xe2\x80\xa6"
          ancestors = ancestors[-2, 2]
        end
        b += ancestors.collect {|p| link_to_project(p, {:jump => current_menu_item}, :class => 'ancestor') }
      end
      b << content_tag(:span, h(@project), class: 'current-project')
      if b.size > 1
        separator = content_tag(:span, ' &raquo; '.html_safe, class: 'separator')
        path = safe_join(b[0..-2], separator) + separator
        b = [content_tag(:span, path.html_safe, class: ''), b[-1]]
      end
      safe_join b
    end
  end
end
