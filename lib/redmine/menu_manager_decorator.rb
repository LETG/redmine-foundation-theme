Redmine::MenuManager::MenuHelper.class_eval do
  # Renders the application main menu
  def render_main_menu(project, options = {})
    render_menu((project && !project.new_record?) ? :project_menu : :application_menu, project, options)
  end

  def display_main_menu?(project)
    menu_name = project && !project.new_record? ? :project_menu : :application_menu
    Redmine::MenuManager.items(menu_name).children.present?
  end

  def render_menu(menu, project=nil, options={})
    links = []
    menu_items_for(menu, project) do |node|
      links << render_menu_node(node, project)
    end
    links.empty? ? nil : content_tag('ul', links.join("\n").html_safe, options)
  end

  def menu_items_for(menu, project=nil)
    items = []
    Redmine::MenuManager.items(menu).root.children.each do |node|
      if allowed_node?(node, User.current, project)
        if block_given?
          yield node
        else
          items << node  # TODO: not used?
        end
      end
    end
    return block_given? ? nil : items
  end

  def allowed_node?(node, user, project)
    return false if node.name == :my_page
    raise MenuError, ":child_menus must be an array of MenuItems" unless node.is_a? Redmine::MenuManager::MenuItem
    node.allowed?(user, project)
  end
end
