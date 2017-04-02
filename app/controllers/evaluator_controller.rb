class EvaluatorController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    if params[:list]
      value = value_them(params[:list])
    end
    if value
      @value = value
    end
    render "index"
  end

  def value_them(list)
    running_total = 0
    line_items = list.split("\r\n")
    line_items.each do |i|
      card = identify(i)
      quantity = quantify(i)
      running_total += get_value(card)
    end
    running_total
  end

  def identify(item)
    set = extract_set(item)
    card_name = extract_card(item)
  end

  def extract_set(item)
    set_names = Sett.all.map{|s| s.plaintext_name}
    set_names.each do |set|
      item
  end

  def lev s, t
  return t.size if s.empty?
  return s.size if t.empty?
  return [ (lev s.chop, t) + 1,
           (lev s, t.chop) + 1,
           (lev s.chop, t.chop) + (s[-1, 1] == t[-1, 1] ? 0 : 1)
       ].min
  end

  ## needs doing
  def get_value(card)
    cards = Card.where(name: item)
    values = cards.map { |c| c.value }
    values.compact.reject{|x| x < 0.1}.min
  end

end