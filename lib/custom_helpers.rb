module CustomHelpers
  def table_of_contents
    content = ::File.read(current_page.source_file)

    # remove YAML frontmatter
    content = content.gsub(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m,'')

    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML_TOC.new(nesting_level: 3)
    )
    markdown.render(content)
  end
end
