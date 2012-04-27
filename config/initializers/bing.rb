def translator
  TranslatorSingleton.instance.translator
end

def TranslatorSingleton
  include Singleton

  def initialize
    @translator = BingTranslator.new ENV["API_KEY"]||""
  end
  
end
