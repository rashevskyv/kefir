module Jekyll
  class SpoilerBlock < Liquid::Block
    def initialize (tag_name, markup, tokens)
      super
      @summary = markup.strip
    end

    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      output = '<details class="spoiler">'
      output << "<summary class=\"spoiler-title\">#{@summary.empty? ? 'Открыть' : @summary}</summary>"
      output << '<div class="spoiler-body">'
      output << converter.convert(super)
      output << '</div>'
      output << '</details>'
    end
  end
end

Liquid::Template.register_tag('spoiler', Jekyll::SpoilerBlock)