module MailerHelper
  include ApplicationHelper

  def truncate_for_mail_shaper(str_full, is_text = false)
    max_lines = [RedmineMailShaper.settings[:diff_max_lines_displayed].to_i, 0].max
    newline_seperator = "\r\n"

    if is_text || max_lines == 0
      str_truncated = str_full
    else
      str_truncated = str_full.split(newline_seperator, max_lines+1)[0...max_lines].join(newline_seperator)
      truncated = (str_full.count(newline_seperator) > max_lines)
      span_diff_size = str_truncated.scan('<span class="diff_').size - str_truncated.scan('</span>').size

      str_truncated << newline_seperator
      str_truncated << '</span>' * span_diff_size if span_diff_size > 0
      str_truncated << newline_seperator << l(:text_diff_truncated) if truncated
    end

    str_truncated.html_safe
  end

  def convert_diff_to_html_diff(diff)
    newline_seperator = "\r\n"
    htmldiff = "<pre>"

    diff.gsub!(newline_seperator, "\n")

    diff.split("\n").each do |line|
      case line
      when /^\+/
        htmldiff << line.gsub(/^\+/, '<span class="diff_in">') << '</span>' << "\n"
      when /^\-/
        htmldiff << line.gsub(/^\-/, '<span class="diff_out">') << '</span>' << "\n"
      else
        htmldiff << line << "\n"
      end
    end

    htmldiff << "</pre>" << "\n"
    Rails.logger.debug "HTMLDIFF: #{htmldiff.inspect}"
    htmldiff.html_safe
  end

end

