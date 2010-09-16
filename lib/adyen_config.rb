class AdyenConfig
 
  def self.skin_code
    @@skin_code ||= configuration['development']['Form']['skins'].values.first['skin_code']
  end

  def self.shared_secret
    @@shared_secret ||= configuration['development']['Form']['skins'].values.first['shared_secret']
  end

  private

  def self.configuration
    @@configuration ||= YAML.load(File.read(Rails.root + 'config/adyen.yml'))
  end

end
