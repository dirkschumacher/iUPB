class PagesController < HighVoltage::PagesController
  before_filter :set_cache_header
end
