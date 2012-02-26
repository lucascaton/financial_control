# encoding: utf-8
# Module created by szimek (https://gist.github.com/szimek)
# And adapted by Lucas Catón
# Source: https://gist.github.com/934886

module IntegrationHelpers
  def select_date(field, options = {})
    date = options[:with]
    find(:xpath, '//select[contains(@id, "_3i")]').find(:xpath, ::XPath::HTML.option(date.day.to_s)).select_option
    find(:xpath, '//select[contains(@id, "_2i")]').find(:xpath, ::XPath::HTML.option(I18n.l(date, :format => :only_month))).select_option
    find(:xpath, '//select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(date.year.to_s)).select_option
  end

  def select_time(field, options = {})
    time = options[:with]
    find(:xpath, '//select[contains(@id, "_4i")]').find(:xpath, ::XPath::HTML.option(time.hour.to_s.rjust(2,'0'))).select_option
    find(:xpath, '//select[contains(@id, "_5i")]').find(:xpath, ::XPath::HTML.option(time.min.to_s.rjust(2,'0'))).select_option
  end

  def select_datetime(field, options = {})
    select_date(field, options)
    select_time(field, options)
  end
end
