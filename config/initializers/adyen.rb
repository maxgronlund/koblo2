configuration = YAML.load(File.read(Rails.root + 'config/adyen.yml'))
Adyen.load_config(configuration[Rails.env])

