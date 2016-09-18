module ReferenceByLanguage
  # link to page with given reference and identical language
  def link(ref)
    page = @context.environments.first[PAGE]
    setlang(ref, item_property(page, LANG))
  end

  # link to page with given reference and given language
  def setlang(ref, lang)
    pages = @context.registers[:site].pages
    nextpages = JFilter.where(JFilter.where(pages, REF, ref), LANG, lang)
    if nextpages.empty?
      '/404.html'
    else
      item_property(nextpages.first, URL)
    end
  end

  private
  REF='ref'
  URL='url'
  LANG='lang'
  PAGE='page'

  class JFilterClass
    include Jekyll::Filters
  end
  JFilter = JFilterClass.new

  def item_property(item, property)
    if item.respond_to?(:to_liquid)
      item.to_liquid[property.to_s]
    elsif item.respond_to?(:data)
      item.data[property.to_s]
    else
      item[property.to_s]
    end
  end
end

Liquid::Template.register_filter(ReferenceByLanguage)
