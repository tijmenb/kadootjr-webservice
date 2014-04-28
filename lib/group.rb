require 'yaml'

class Group
  def self.all
    @all ||= YAML.load(File.read("./config/categories.yml"))
  end
end
