require 'yaml'

class Group
  def self.all
    @all ||= YAML.load(File.read("./data/groups.yml"))
  end
end
