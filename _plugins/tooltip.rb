module Jekyll
  class TooltipBlock < Liquid::Block
    def initialize (tag_name, markup, tokens)
      super
      @summary = markup.strip
    end

    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(Jekyll::Converters::Markdown)

      output = '<div class="tooltip">'
      output << "#{@summary}"
      output << '<div class="bottom">'
      output << converter.convert(super)
      output << '</div>'
      output << '</div>'
    end
  end
end

Liquid::Template.register_tag('tooltip', Jekyll::TooltipBlock)