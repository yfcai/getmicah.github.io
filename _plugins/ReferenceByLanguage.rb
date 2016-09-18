module ReferenceByLanguage
  # link to page with given reference and identical language
  def link(ref)
    page = @context.environments.first[PAGE]
    setlang(ref, item_property(page, LANG))
  end

  # pass reference and language as 2 words of the input
  # to work around the possibility that github-pages
  # may not be able to pass arguments to filters (18.09.2016)
  def reflang(reflang)
    if reflang
      ref, lang = reflang.split
      setlang(ref, lang)
    else
      '/404.html'
    end
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
