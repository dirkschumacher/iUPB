def translator
  BingTranslator.new ENV["API_KEY"]||""
end