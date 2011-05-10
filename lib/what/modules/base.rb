class What::Modules::Base
  def initialize
    @config = What::Config[self.name]
  end

  def name
    What::Helpers.underscore(self.class.name.split('::').last)
  end

  def check!
    raise "Module #{self.class.name} doesn't override 'check!'"
  end

  def status
    { :health => health }.merge(details)
  end

  def health
    raise "Module #{self.class.name} doesn't override 'health'"
  end

  def details
    {}
  end
end

