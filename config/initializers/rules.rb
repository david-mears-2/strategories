Rails.configuration.after_initialize do
  YAML.load_file(Rails.root.join("config/rules.yml")).each do |rule|
    Rule.find_or_create_by(rule)
  end
end