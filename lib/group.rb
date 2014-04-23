require 'yaml'

class Group
  def self.all
    @all ||= YAML.load(File.read("./configs/categories.yml"))
  end
end
