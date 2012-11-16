require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = '&hellip;'

    def container_attributes
      super.except(:anchor_options)
    end

    def to_html
      list_items = pagination.map do |item|
        case item
          when Fixnum
            page_number(item)
          else
            send(item)
        end
      end

      html_container(tag('ul', list_items.join(@options[:link_separator])))
    end

    protected

    def page_number(page)
      anchor_options = @options[:anchor_options]
      anchor_options ||= {}
      if page == current_page
        tag('li', link(page, page, anchor_options), :class => 'active')
      else
        anchor_options.merge!(:rel => rel_value(page))
        tag('li', link(page, page, anchor_options))
      end
    end

    def gap
      tag('li', link(ELLIPSIS, '#'), :class => 'disabled')
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], 'prev')
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], 'next')
    end

    def previous_or_next_page(page, text, classname)
      anchor_options = @options[:anchor_options]
      anchor_options ||= {}
      if page
        tag('li', link(text, page, anchor_options), :class => classname)
      else
        tag('li', link(text, '#', anchor_options), :class => "%s disabled" % classname)
      end
    end
  end
end
